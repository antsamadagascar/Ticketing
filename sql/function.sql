---
--  1. Fonction pour effectuer un recherche de vol (ok)
---
CREATE OR REPLACE FUNCTION rechercher_vols(
    p_ville_depart_id INTEGER DEFAULT NULL,
    p_ville_arrivee_id INTEGER DEFAULT NULL,
    p_date_depart TIMESTAMP DEFAULT NULL,
    p_type_siege_id INTEGER DEFAULT NULL,
    p_prix_min DECIMAL(10, 2) DEFAULT NULL,
    p_prix_max DECIMAL(10, 2) DEFAULT NULL,
    p_nombre_passagers INTEGER DEFAULT NULL
)
RETURNS TABLE (
    vol_id INTEGER,
    numero_vol VARCHAR(20),
    date_depart TIMESTAMP,
    date_arrivee TIMESTAMP,
    prix_final DECIMAL(10, 2),
    type_siege_nom VARCHAR(50),
    sieges_disponibles BIGINT,
    est_promotion BOOLEAN,
    ville_depart_nom VARCHAR(100), 
    ville_arrivee_nom VARCHAR(100) 
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        v.id AS vol_id,
        v.numero_vol,
        v.date_depart,
        v.date_arrivee,
        sv.prix_final,
        ts.nom AS type_siege_nom,
        COUNT(sv.id) AS sieges_disponibles,
        BOOL_OR(sv.est_promotion) AS est_promotion,
        vd.nom AS ville_depart_nom, 
        va.nom AS ville_arrivee_nom 
    FROM 
        vol v
    JOIN 
        siege_vol sv ON v.id = sv.vol_id
    JOIN 
        siege s ON sv.siege_id = s.id
    JOIN 
        avion_type_siege ats ON s.avion_type_siege_id = ats.id
    JOIN 
        type_siege ts ON ats.type_siege_id = ts.id
    JOIN 
        ville vd ON v.ville_depart_id = vd.id 
    JOIN 
        ville va ON v.ville_arrivee_id = va.id 
    WHERE 
        (p_ville_depart_id IS NULL OR v.ville_depart_id = p_ville_depart_id)
        AND (p_ville_arrivee_id IS NULL OR v.ville_arrivee_id = p_ville_arrivee_id)
        AND (p_date_depart IS NULL OR v.date_depart >= p_date_depart)
        AND (p_type_siege_id IS NULL OR ts.id = p_type_siege_id)
        AND (p_prix_min IS NULL OR sv.prix_final >= p_prix_min)
        AND (p_prix_max IS NULL OR sv.prix_final <= p_prix_max)
        AND sv.est_disponible = TRUE
    GROUP BY 
        v.id, v.numero_vol, v.date_depart, v.date_arrivee, sv.prix_final, ts.nom, vd.nom, va.nom
    HAVING 
        (p_nombre_passagers IS NULL OR COUNT(sv.id) >= p_nombre_passagers);
END;
$$ LANGUAGE plpgsql;

---
--  2. Fonction pour l'Application des règles métier(ok)
---
CREATE OR REPLACE FUNCTION verifier_heures_reservation()
RETURNS TRIGGER AS $$
DECLARE
    v_heures_avant_vol INTEGER;
BEGIN
    -- Récupérer le nombre d'heures avant le vol où la réservation est possible
    SELECT heures_avant_vol INTO v_heures_avant_vol
    FROM regle_reservation
    WHERE active = TRUE;

    -- Vérifie si la réservation est faite dans les délais
    IF (NEW.date_reservation > (SELECT date_depart FROM vol WHERE id = NEW.vol_id) - INTERVAL '1 hour' * v_heures_avant_vol) THEN
        RAISE EXCEPTION 'La réservation doit être faite au moins % heures avant le vol.', v_heures_avant_vol;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_verifier_heures_reservation
BEFORE INSERT ON reservation
FOR EACH ROW
EXECUTE FUNCTION verifier_heures_reservation();


---
--  3. Fonction pour Vérification des heures d'annulation après la réservation (ok)
---
CREATE OR REPLACE FUNCTION verifier_heures_annulation()
RETURNS TRIGGER AS $$
DECLARE
    v_heures_apres_reservation INTEGER;
BEGIN
    -- Récupérer le nombre d'heures après la réservation où l'annulation est possible
    SELECT heures_apres_reservation INTO v_heures_apres_reservation
    FROM regle_annulation
    WHERE active = TRUE;

    -- Vérifier si l'annulation est faite dans les délais
    IF (NEW.statut = FALSE AND (NOW() > (SELECT date_reservation FROM reservation WHERE id = NEW.id) + INTERVAL '1 hour' * v_heures_apres_reservation)) THEN
        RAISE EXCEPTION 'L''annulation doit être faite dans les % heures suivant la réservation.', v_heures_apres_reservation;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_verifier_heures_annulation
BEFORE UPDATE ON reservation
FOR EACH ROW
EXECUTE FUNCTION verifier_heures_annulation();

---
--  4. Fonction pour appliquer les promotions aux sièges 
---
CREATE OR REPLACE FUNCTION appliquer_promotion_siege()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE siege_vol sv
    SET 
        est_promotion = TRUE, 
        taux_promotion = NEW.taux_promotion, 
        prix_final = sv.prix_base * (1 - NEW.taux_promotion / 100) 
    FROM siege s
    JOIN avion_type_siege ats ON s.avion_type_siege_id = ats.id
    WHERE sv.vol_id = NEW.vol_id 
      AND ats.type_siege_id = NEW.type_siege_id 
      AND sv.siege_id = s.id 
      AND (SELECT date_depart FROM vol WHERE id = NEW.vol_id) BETWEEN NEW.date_debut AND NEW.date_fin;

    RETURN NEW; 
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_appliquer_promotion
AFTER INSERT OR UPDATE ON promotion_vol
FOR EACH ROW
EXECUTE FUNCTION appliquer_promotion_siege();

---
--  5. Fonction pour effectuer une reservation vols
---
CREATE OR REPLACE FUNCTION reserver_siege()
RETURNS TRIGGER AS $$
DECLARE
    v_siege_disponible BOOLEAN;
BEGIN
    -- Vérifier si le siège est disponible
    SELECT est_disponible INTO v_siege_disponible
    FROM siege_vol
    WHERE id = NEW.siege_vol_id;

    IF NOT v_siege_disponible THEN
        RAISE EXCEPTION 'Le siège n''est pas disponible pour la réservation.';
    END IF;

    -- Mettre à jour le statut du siège à "réservé"
    UPDATE siege_vol
    SET est_disponible = FALSE
    WHERE id = NEW.siege_vol_id;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_reserver_siege
BEFORE INSERT ON detail_reservation
FOR EACH ROW
EXECUTE FUNCTION reserver_siege();


---
--  6. Fonction pour calculer le montant total du reservation (ok)
--- 
CREATE OR REPLACE FUNCTION calculer_montant_total()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE reservation
    SET montant_total = (
        SELECT SUM(prix_unitaire)
        FROM detail_reservation
        WHERE reservation_id = NEW.reservation_id
    )
    WHERE id = NEW.reservation_id;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_calculer_montant_total
AFTER INSERT OR UPDATE OR DELETE ON detail_reservation
FOR EACH ROW
EXECUTE FUNCTION calculer_montant_total();

---
--  7. Fonction pour recuperer les prix unitaire d'un siege (Ok0)
---
CREATE OR REPLACE FUNCTION recuperer_prix_unitaire()
RETURNS TRIGGER AS $$
BEGIN
    NEW.prix_unitaire := (SELECT prix_final FROM siege_vol WHERE id = NEW.siege_vol_id);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_recuperer_prix_unitaire
BEFORE INSERT ON detail_reservation
FOR EACH ROW
EXECUTE FUNCTION recuperer_prix_unitaire();

---
-- 8. Fonction pour recuperer liberer les siege apres annulation
---
CREATE OR REPLACE FUNCTION liberer_sieges_apres_annulation()
RETURNS TRIGGER AS $$
BEGIN
    -- Si la réservation est annulée (statut passe à FALSE)
    IF OLD.statut = TRUE AND NEW.statut = FALSE THEN
        -- Mettre à jour tous les sièges associés dans siege_vol pour les rendre disponibles
        UPDATE siege_vol
        SET est_disponible = TRUE
        WHERE id IN (
            SELECT dr.siege_vol_id
            FROM detail_reservation dr
            WHERE dr.reservation_id = NEW.id
        );
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_liberer_sieges_apres_annulation
AFTER UPDATE ON reservation
FOR EACH ROW
EXECUTE FUNCTION liberer_sieges_apres_annulation();
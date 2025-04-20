---
-- view pour listes les reservation des passages
---
CREATE OR REPLACE VIEW view_reservations_passagers AS
SELECT
    r.id AS reservation_id,
    u.id AS id,
    u.nom AS nom_passager,
    u.prenom AS prenom_passager,
    u.email AS email_passager,
    v.id AS volId,
    v.numero_vol,
    v.date_depart,
    v.date_arrivee,
    vd.nom AS ville_depart,
    va.nom AS ville_arrivee,
    r.montant_total,
    r.date_reservation,
    r.statut AS statut_reservation,
    r.nombre_passager,
    STRING_AGG(DISTINCT p.nom || ' ' || p.prenom, ', ') AS liste_passagers,
    STRING_AGG(DISTINCT s.numero, ', ') AS liste_sieges
FROM
    reservation r
JOIN
    utilisateur u ON r.utilisateur_id = u.id
JOIN
    vol v ON r.vol_id = v.id
JOIN
    ville vd ON v.ville_depart_id = vd.id
JOIN
    ville va ON v.ville_arrivee_id = va.id
LEFT JOIN
    passager p ON r.id = p.reservation_id
LEFT JOIN
    detail_reservation dr ON r.id = dr.reservation_id
LEFT JOIN
    siege_vol sv ON dr.siege_vol_id = sv.id
LEFT JOIN
    siege s ON sv.siege_id = s.id
WHERE 
    r.statut IS TRUE
GROUP BY
    r.id, u.id, u.nom, u.prenom, u.email, v.id, v.numero_vol, v.date_depart, v.date_arrivee,
    vd.nom, va.nom, r.montant_total, r.date_reservation, r.statut, r.nombre_passager;


---
-- view pour recuperer les informations de reservation utilisateur
---
CREATE OR REPLACE VIEW reservation_details_view AS
SELECT 
    r.id AS reservation_id,
    r.date_reservation,
    r.statut AS reservation_statut,
    r.nombre_passager,
    r.montant_total,
    u.id AS utilisateur_id,
    u.nom AS utilisateur_nom,
    u.prenom AS utilisateur_prenom,
    u.email AS utilisateur_email,
    v.id AS vol_id,
    v.numero_vol,
    v.date_depart AS vol_date_depart,
    v.date_arrivee AS vol_date_arrivee,
    vd.nom AS ville_depart,
    vd.code_aeroport AS code_aeroport_depart,
    va.nom AS ville_arrivee,
    va.code_aeroport AS code_aeroport_arrivee,
    a.modele AS avion_modele,
    p.id AS passager_id,
    p.nom AS passager_nom,
    p.prenom AS passager_prenom,
    p.date_naissance AS passager_date_naissance,
    EXTRACT(YEAR FROM AGE(v.date_depart, p.date_naissance)) AS passager_age,
    p.passeport_file_data,
    dr.id AS detail_reservation_id,
    dr.prix_unitaire,
    sv.id AS siege_vol_id,
    s.numero AS siege_numero,
    ts.nom AS siege_type,
    sv.prix_base AS siege_prix_base,
    sv.prix_final AS siege_prix_final,
    sv.est_promotion AS siege_en_promotion,
    sv.taux_promotion AS siege_taux_promotion,
    pv.taux_promotion AS promotion_vol_taux,
    rp.pourcentage_prix AS regle_pourcentage_prix
FROM reservation r
JOIN utilisateur u ON r.utilisateur_id = u.id
JOIN vol v ON r.vol_id = v.id
JOIN ville vd ON v.ville_depart_id = vd.id
JOIN ville va ON v.ville_arrivee_id = va.id
JOIN avion a ON v.avion_id = a.id
JOIN passager p ON p.reservation_id = r.id
JOIN detail_reservation dr ON dr.reservation_id = r.id AND dr.passager_id = p.id
JOIN siege_vol sv ON dr.siege_vol_id = sv.id
JOIN siege s ON sv.siege_id = s.id
JOIN avion_type_siege ats ON s.avion_type_siege_id = ats.id
JOIN type_siege ts ON ats.type_siege_id = ts.id
LEFT JOIN promotion_vol pv ON v.id = pv.vol_id AND ts.id = pv.type_siege_id
LEFT JOIN regle_prix rp ON EXTRACT(YEAR FROM AGE(v.date_depart, p.date_naissance)) BETWEEN rp.age_min AND rp.age_max;
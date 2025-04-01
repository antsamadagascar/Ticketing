INSERT INTO utilisateur (email, mot_de_passe, nom, prenom, date_naissance, telephone, role, date_creation) 
VALUES 
('antsamadagascar@gmail.com', crypt('1234', gen_salt('bf')), 'Ratovonandrasana', 'Aina Ny Antsa','2005-07-29' , '1234567890', 'manager', NOW()),
('landy@gmail.com', crypt('1234', gen_salt('bf')), 'raisoa', 'landy', NULL, '0987654321', 'user', NOW()),
('ivo@gmail.com', crypt('1234', gen_salt('bf')), 'kilonga', 'mihary', NULL, '1122334455', 'user', NOW());

INSERT INTO avion (modele, date_fabrication) VALUES
('Boeing 737', '2020-01-15');

INSERT INTO ville (nom, code_aeroport, pays, fuseau_horaire) VALUES
('Paris', 'CDG', 'France', 'Europe/Paris'),
('New York', 'JFK', 'États-Unis', 'America/New_York');

INSERT INTO type_siege (nom, description, tarif_base) VALUES
('Économique', 'Siège standard avec confort de base', 200.00),
('Premium', 'Siège avec plus d''espace pour les jambes', 350.00),
('Business', 'Siège inclinable avec service haut de gamme', 800.00);

INSERT INTO avion_type_siege (avion_id, type_siege_id, nombre_sieges) VALUES
(1, 1, 100), -- 100 sièges Économique
(1, 2, 20),  -- 20 sièges Premium
(1, 3, 10);  -- 10 sièges Business

INSERT INTO siege (numero, avion_type_siege_id, is_disponible) VALUES
-- Sièges Économique (avion_type_siege_id = 1)
('1A', 1, TRUE),
('1B', 1, TRUE),
('2A', 1, TRUE),
('2B', 1, TRUE),
('3A', 1, TRUE),
-- Sièges Premium (avion_type_siege_id = 2)
('10A', 2, TRUE),
('10B', 2, TRUE),
('11A', 2, TRUE),
('11B', 2, TRUE),
('12A', 2, TRUE),
-- Sièges Business (avion_type_siege_id = 3)
('20A', 3, TRUE),
('20B', 3, TRUE),
('21A', 3, TRUE),
('21B', 3, TRUE),
('22A', 3, TRUE);

INSERT INTO vol (numero_vol, ville_depart_id, ville_arrivee_id, date_depart, date_arrivee, avion_id, statut) VALUES
('AF123', 1, 2, '2025-04-21 10:00:00', '2025-04-14 13:00:00', 1, 0);

INSERT INTO siege_vol (vol_id, siege_id, est_promotion, taux_promotion, prix_base, prix_final, est_disponible) VALUES
-- Sièges Économique (avec 10% de promotion)
(1, 1, TRUE, 10.00, 200.00, 180.00, TRUE),
(1, 2, TRUE, 10.00, 200.00, 180.00, TRUE),
(1, 3, TRUE, 10.00, 200.00, 180.00, TRUE),
(1, 4, TRUE, 10.00, 200.00, 180.00, TRUE),
(1, 5, TRUE, 10.00, 200.00, 180.00, TRUE),
-- Sièges Premium (sans promotion)
(1, 6, FALSE, 0.00, 350.00, 350.00, TRUE),
(1, 7, FALSE, 0.00, 350.00, 350.00, TRUE),
(1, 8, FALSE, 0.00, 350.00, 350.00, TRUE),
(1, 9, FALSE, 0.00, 350.00, 350.00, TRUE),
(1, 10, FALSE, 0.00, 350.00, 350.00, TRUE),
-- Sièges Business (sans promotion)
(1, 11, FALSE, 0.00, 800.00, 800.00, TRUE),
(1, 12, FALSE, 0.00, 800.00, 800.00, TRUE),
(1, 13, FALSE, 0.00, 800.00, 800.00, TRUE),
(1, 14, FALSE, 0.00, 800.00, 800.00, TRUE),
(1, 15, FALSE, 0.00, 800.00, 800.00, TRUE);

INSERT INTO regle_reservation (heures_avant_vol, active) VALUES
(24, TRUE);

INSERT INTO regle_annulation (heures_apres_reservation, active) VALUES
(48, TRUE);

-- Étape 1 : Insérer la réservation
INSERT INTO reservation (utilisateur_id, vol_id, date_reservation, statut, nombre_passager, montant_total)
VALUES (1, 1, '2025-04-18 10:00:00', TRUE, 5, 0) -- montant_total sera mis à jour par le trigger
RETURNING id; -- Notez l'ID généré (par exemple, 1)

-- Étape 2 : Insérer les passagers
INSERT INTO passager (reservation_id, nom, prenom, date_naissance, passeport_file_data) VALUES
(1, 'Martin', 'Thomas', '1980-01-01', 'passeport1.png'),
(1, 'Lefèvre', 'Sophie', '1985-01-01', 'passeport2.png'),
(1, 'Martin', 'Lucas', '2015-01-01', 'passeport3.png'),
(1, 'Martin', 'Emma', '2016-01-01', 'passeport4.png'),
(1, 'Martin', 'Chloé', '2017-01-01', 'passeport5.png');

RETURNING id; -- Notez les IDs générés (par exemple, 1, 2, 3, 4, 5)

-- Étape 3 : Insérer les détails de la réservation
INSERT INTO detail_reservation (reservation_id, siege_vol_id, prix_unitaire, passager_id) VALUES
(1, 1, 800.00, 1),
(1, 2, 800.00, 2),
(1, 3, 144.00, 3),
(1, 4, 144.00, 4),
(1, 6, 280.00, 5);

-- Vérifier le montant_total (mis à jour par le trigger)
SELECT montant_total FROM reservation WHERE id = 1; -- Devrait retourner 2312.00

INSERT INTO promotion_vol (vol_id, type_siege_id, taux_promotion, date_debut, date_fin) VALUES
(1, 2, 10, '2023-12-01 00:00:00', '2023-12-31 23:59:59'); 

INSERT INTO regle_reservation (heures_avant_vol, active) VALUES
(24, TRUE); 

INSERT INTO regle_annulation (heures_apres_reservation, active) VALUES
(24, TRUE); 

Insert into regle_prix (age_min,age_max,pourcentage_prix)  values (5,13,30);
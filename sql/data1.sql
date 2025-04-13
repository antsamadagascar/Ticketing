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
('AF123', 1, 2, '2025-04-15 10:00:00', '2025-04-15 13:00:00', 1, 0);

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

INSERT INTO promotion_vol (vol_id, type_siege_id, taux_promotion, date_debut, date_fin) VALUES
(1, 1, 10.00, '2025-04-01 00:00:00', '2025-04-14 23:59:59');

INSERT INTO regle_reservation (heures_avant_vol, active) VALUES
(24, TRUE);

INSERT INTO regle_annulation (heures_apres_reservation, active) VALUES
(48, TRUE);
INSERT INTO utilisateur (email, mot_de_passe, nom, prenom, date_naissance, telephone, role, date_creation) 
VALUES 
('antsamadagascar@gmail.com', crypt('1234', gen_salt('bf')), 'Ratovonandrasana', 'Aina Ny Antsa','2005-07-29' , '1234567890', 'manager', NOW()),
('landy@gmail.com', crypt('1234', gen_salt('bf')), 'raisoa', 'landy', NULL, '0987654321', 'user', NOW()),
('ivo@gmail.com', crypt('1234', gen_salt('bf')), 'kilonga', 'mihary', NULL, '1122334455', 'user', NOW());

INSERT INTO avion (modele,date_fabrication) VALUES
('Boeing 737-800', '2018-05-12'),
('Airbus A320','2019-08-23'),
('Boeing 787-9','2017-11-05'),
('Airbus A330-300', '2016-03-17'),
('Embraer E190','2020-01-08');

INSERT INTO ville (nom, code_aeroport, pays, fuseau_horaire) VALUES
('Paris', 'CDG', 'France', 'Europe/Paris'),
('New York', 'JFK', 'États-Unis', 'America/New_York'),
('Tokyo', 'HND', 'Japon', 'Asia/Tokyo'),
('Casablanca', 'CMN', 'Maroc', 'Africa/Casablanca'),
('Dubai', 'DXB', 'Émirats Arabes Unis', 'Asia/Dubai'),
('Londres', 'LHR', 'Royaume-Uni', 'Europe/London'),
('Madrid', 'MAD', 'Espagne', 'Europe/Madrid'),
('Rome', 'FCO', 'Italie', 'Europe/Rome'),
('Berlin', 'BER', 'Allemagne', 'Europe/Berlin'),
('Istanbul', 'IST', 'Turquie', 'Europe/Istanbul');

INSERT INTO type_siege (nom, description, tarif_base) VALUES
('Économique', 'Classe économique avec confort standard', 200.00),
('Affaires', 'Classe affaires avec plus d''espace et de services', 500.00),
('Première classe', 'Luxe et confort absolus', 1000.00);

INSERT INTO avion_type_siege (avion_id, type_siege_id, nombre_sieges) VALUES
(1, 1, 150), 
(1, 2, 20);  

INSERT INTO siege (numero, avion_type_siege_id, is_disponible) VALUES
('1A', 1, TRUE), 
('2B', 2, TRUE); 


INSERT INTO vol (numero_vol, ville_depart_id, ville_arrivee_id, date_depart, date_arrivee, avion_id, statut) VALUES
('AF123', 1, 2, '2023-12-25 10:00:00', '2023-12-25 14:00:00', 1, TRUE);

INSERT INTO siege_vol (vol_id, siege_id, est_promotion, taux_promotion,prix_base, prix_final, est_disponible) VALUES
(1, 1, FALSE, 0,50, 100.00, TRUE), 
(1, 2, TRUE, 10,200, 270.00, TRUE); 

INSERT INTO promotion_vol (vol_id, type_siege_id, taux_promotion, date_debut, date_fin) VALUES
(1, 2, 10, '2023-12-01 00:00:00', '2023-12-31 23:59:59'); 

INSERT INTO regle_reservation (heures_avant_vol, active) VALUES
(24, TRUE); 

INSERT INTO regle_annulation (heures_apres_reservation, active) VALUES
(24, TRUE); 

Insert into regle_prix (age_min,age_max,pourcentage_prix)  values (5,13,30);
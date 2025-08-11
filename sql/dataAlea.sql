
---
-- data fitsarana
--
INSERT INTO avion (modele, date_fabrication) VALUES
('Air Madagascar', '2020-01-15'),
('Air France', '2020-01-15');


INSERT INTO ville (nom, code_aeroport, pays, fuseau_horaire) VALUES
('Antananarivo', 'ANT', 'Madagascar', 'Europe/Paris'),
('Paris CDG', 'CDG', 'France', 'America/New_York'),
('Mauritius', 'MAU', 'Mauritius', 'Mauritius'),
('Addis Abeba', 'ADD', 'Addis Abeba', 'Addis Abeba');

INSERT INTO type_siege (nom, description, tarif_base) VALUES
('Économique', 'Siège standard avec confort de base', 200.00),
('Affaire', 'Siège avec plus d''espace pour les jambes', 200.00);

---
-- données nombre siege par type siege avion Boeing 737
---
INSERT INTO avion_type_siege (avion_id, type_siege_id, nombre_sieges) VALUES
(1, 1, 5), -- 100 sièges Économique
(2, 1, 2); -- 100 sièges Économique

---
-- données siege avion Boeing 737
---
INSERT INTO siege (numero, avion_type_siege_id, is_disponible) VALUES
-- Sièges Économique (avion_type_siege_id = 1)
('num1', 1, TRUE),
('num2', 1, TRUE),
('num3', 1, TRUE),
('num4', 1, TRUE),
('num5', 1, TRUE),

('num1', 2, TRUE),
('num2', 2, TRUE);


INSERT INTO vol (numero_vol, ville_depart_id, ville_arrivee_id, date_depart, date_arrivee, avion_id, statut)
VALUES 
('VOL1', 1, 4,'2025-08-11 08:00:00', '2025-08-12 12:00:00 ', 1, 0),
('VOL2', 2, 3,'2025-09-03 21:00:00', '2025-09-04 21:00:00', 2, 0);

INSERT INTO public.reservation (utilisateur_id,vol_id,date_reservation,statut,nombre_passager,montant_total,is_payer) VALUES
	 (3,3,'2025-08-04 12:15:00',true,1,200.00,1),
	 (3,3,'2025-08-08 12:16:00',true,1,200.00,0),
	 (3,3,'2025-08-09 12:13:00',true,1,200.00,1),
	 (3,3,'2025-08-14 12:17:00',true,1,300.00,0),
	 (3,3,'2025-08-15 12:18:00',true,1,300.00,1),
	 (3,4,'2025-08-30 12:19:00',true,1,200.00,1),
	 (3,4,'2025-08-30 12:22:00',true,1,200.00,1);


INSERT INTO public.passager (reservation_id,nom,prenom,date_naissance,passeport_file_data) VALUES
	 (1,'Rabe','Ivo','2005-08-01','560044.jpg'),
	 (2,'Ramihajanirina','rasoloniaina','1983-08-11','666312.jpg'),
	 (3,'Jean','Dupont','2006-08-29','741012.jpg'),
	 (4,'Ratovoniaina','Ny Faneva','2012-04-04','1300593.png'),
	 (5,'Rabe','Ivo','2004-09-01','1300593.png'),
	 (6,'Randria','Fenitra','1999-08-11','2022.PNG'),
	 (7,'Ramihajanirina','tsikiniaina','2012-01-01','666312.jpg');

INSERT INTO public.detail_reservation (reservation_id,siege_vol_id,prix_unitaire,passager_id,is_payer) VALUES
	 (1,5,20.00,1,0),
	 (2,4,200.00,2,0),
	 (3,3,20.00,3,0),
	 (4,2,40.00,4,0),
	 (5,1,20.00,5,0),
	 (6,7,200.00,6,0),
	 (7,6,40.00,7,0);


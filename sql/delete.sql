-- Désactiver temporairement les contraintes de clé étrangère
ALTER TABLE avion_type_siege DROP CONSTRAINT avion_type_siege_avion_id_fkey;
ALTER TABLE avion_type_siege DROP CONSTRAINT avion_type_siege_type_siege_id_fkey;
ALTER TABLE siege DROP CONSTRAINT siege_avion_type_siege_id_fkey;
ALTER TABLE vol DROP CONSTRAINT vol_ville_depart_id_fkey;
ALTER TABLE vol DROP CONSTRAINT vol_ville_arrivee_id_fkey;
ALTER TABLE vol DROP CONSTRAINT vol_avion_id_fkey;
ALTER TABLE siege_vol DROP CONSTRAINT siege_vol_vol_id_fkey;
ALTER TABLE siege_vol DROP CONSTRAINT siege_vol_siege_id_fkey;
ALTER TABLE reservation DROP CONSTRAINT reservation_utilisateur_id_fkey;
ALTER TABLE detail_reservation DROP CONSTRAINT detail_reservation_reservation_id_fkey;
ALTER TABLE detail_reservation DROP CONSTRAINT detail_reservation_siege_vol_id_fkey;
ALTER TABLE promotion_vol DROP CONSTRAINT promotion_vol_vol_id_fkey;
ALTER TABLE promotion_vol DROP CONSTRAINT promotion_vol_type_siege_id_fkey;

-- Supprimer les données et réinitialiser les séquences
TRUNCATE TABLE avion, ville, type_siege, avion_type_siege, siege, vol, siege_vol, reservation, detail_reservation, promotion_vol, regle_reservation, regle_annulation RESTART IDENTITY CASCADE;

-- Restaurer les contraintes de clé étrangère
ALTER TABLE avion_type_siege ADD CONSTRAINT avion_type_siege_avion_id_fkey FOREIGN KEY (avion_id) REFERENCES avion(id) ON DELETE CASCADE;
ALTER TABLE avion_type_siege ADD CONSTRAINT avion_type_siege_type_siege_id_fkey FOREIGN KEY (type_siege_id) REFERENCES type_siege(id) ON DELETE CASCADE;
ALTER TABLE siege ADD CONSTRAINT siege_avion_type_siege_id_fkey FOREIGN KEY (avion_type_siege_id) REFERENCES avion_type_siege(id) ON DELETE CASCADE;
ALTER TABLE vol ADD CONSTRAINT vol_ville_depart_id_fkey FOREIGN KEY (ville_depart_id) REFERENCES ville(id) ON DELETE CASCADE;
ALTER TABLE vol ADD CONSTRAINT vol_ville_arrivee_id_fkey FOREIGN KEY (ville_arrivee_id) REFERENCES ville(id) ON DELETE CASCADE;
ALTER TABLE vol ADD CONSTRAINT vol_avion_id_fkey FOREIGN KEY (avion_id) REFERENCES avion(id) ON DELETE CASCADE;
ALTER TABLE siege_vol ADD CONSTRAINT siege_vol_vol_id_fkey FOREIGN KEY (vol_id) REFERENCES vol(id) ON DELETE CASCADE;
ALTER TABLE siege_vol ADD CONSTRAINT siege_vol_siege_id_fkey FOREIGN KEY (siege_id) REFERENCES siege(id) ON DELETE CASCADE;
ALTER TABLE reservation ADD CONSTRAINT reservation_utilisateur_id_fkey FOREIGN KEY (utilisateur_id) REFERENCES utilisateur(id);
ALTER TABLE detail_reservation ADD CONSTRAINT detail_reservation_reservation_id_fkey FOREIGN KEY (reservation_id) REFERENCES reservation(id);
ALTER TABLE detail_reservation ADD CONSTRAINT detail_reservation_siege_vol_id_fkey FOREIGN KEY (siege_vol_id) REFERENCES siege_vol(id);
ALTER TABLE promotion_vol ADD CONSTRAINT promotion_vol_vol_id_fkey FOREIGN KEY (vol_id) REFERENCES vol(id);
ALTER TABLE promotion_vol ADD CONSTRAINT promotion_vol_type_siege_id_fkey FOREIGN KEY (type_siege_id) REFERENCES type_siege(id);

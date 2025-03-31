CREATE OR REPLACE VIEW view_reservations_passagers AS
SELECT 
    r.id AS reservation_id,
	u.id,
    u.nom AS nom_passager,
    u.prenom AS prenom_passager,
    u.email AS email_passager,
    v.id as volId,
    v.numero_vol AS numero_vol,
    v.date_depart AS date_depart,
    v.date_arrivee AS date_arrivee,
    vd.nom AS ville_depart,
    va.nom AS ville_arrivee,
    sv.siege_id AS siege_id,
    s.numero AS numero_siege,
    dr.prix_unitaire AS prix_unitaire,
    r.montant_total AS montant_total,
    r.date_reservation AS date_reservation,
    r.statut AS statut_reservation,
    r.passeport_file_data
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
JOIN 
    detail_reservation dr ON r.id = dr.reservation_id
JOIN 
    siege_vol sv ON dr.siege_vol_id = sv.id
JOIN 
    siege s ON sv.siege_id = s.id
WHERE r.statut is true
;


---
-- vol en cours avec promotion
---
CREATE OR REPLACE VIEW view_vols_en_cours_promotions AS
SELECT 
    v.id AS vol_id,
    v.numero_vol AS numero_vol,
    v.date_depart AS date_depart,
    v.date_arrivee AS date_arrivee,
    vd.nom AS ville_depart,
    va.nom AS ville_arrivee,
    a.modele AS modele_avion,
    ts.nom AS type_siege,
    sv.est_promotion AS est_promotion,
    sv.taux_promotion AS taux_promotion,
    sv.prix_base AS prix_base,
    sv.prix_final AS prix_final,
    sv.est_disponible AS est_disponible
FROM 
    vol v
JOIN 
    ville vd ON v.ville_depart_id = vd.id
JOIN 
    ville va ON v.ville_arrivee_id = va.id
JOIN 
    avion a ON v.avion_id = a.id
JOIN 
    siege_vol sv ON v.id = sv.vol_id
JOIN 
    siege s ON sv.siege_id = s.id
JOIN 
    avion_type_siege ats ON s.avion_type_siege_id = ats.id
JOIN 
    type_siege ts ON ats.type_siege_id = ts.id
WHERE 
    v.statut = 0; 
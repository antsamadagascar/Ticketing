CREATE TABLE avion (
    id SERIAL PRIMARY KEY,
    modele VARCHAR(100) NOT NULL,
    date_fabrication DATE NOT NULL
);

CREATE TABLE ville (
    id SERIAL PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    code_aeroport VARCHAR(10) NOT NULL UNIQUE,
    pays VARCHAR(100) NOT NULL,
    fuseau_horaire VARCHAR(50)
);

CREATE TABLE type_siege (
    id SERIAL PRIMARY KEY,
    nom VARCHAR(50) NOT NULL UNIQUE,
    description TEXT,
    tarif_base DECIMAL(10, 2) NOT NULL
);

CREATE TABLE avion_type_siege (
    id SERIAL PRIMARY KEY,
    avion_id INTEGER REFERENCES avion(id) ON DELETE CASCADE,
    type_siege_id INTEGER REFERENCES type_siege(id) ON DELETE CASCADE,
    nombre_sieges INTEGER NOT NULL
);

CREATE TABLE siege (
    id SERIAL PRIMARY KEY,
    numero VARCHAR(10) NOT NULL, 
    avion_type_siege_id INTEGER REFERENCES avion_type_siege(id) ON DELETE CASCADE,
    is_disponible BOOLEAN DEFAULT TRUE
);

CREATE TABLE vol (
    id SERIAL PRIMARY KEY,
    numero_vol VARCHAR(20) NOT NULL UNIQUE,
    ville_depart_id INTEGER NOT NULL REFERENCES ville(id) ON DELETE CASCADE,
    ville_arrivee_id INTEGER NOT NULL REFERENCES ville(id) ON DELETE CASCADE,
    date_depart TIMESTAMP NOT NULL,
    date_arrivee TIMESTAMP NOT NULL,
    avion_id INTEGER NOT NULL REFERENCES avion(id) ON DELETE CASCADE,
    statut SMALLINT NOT NULL DEFAULT 0, -- 0: Programmé, 1: Terminé, -1: Annulé
    CONSTRAINT check_villes_differentes CHECK (ville_depart_id != ville_arrivee_id),
    CONSTRAINT check_statut CHECK (statut IN (0, 1, -1))
);

CREATE TABLE siege_vol (
    id SERIAL PRIMARY KEY,
    vol_id INTEGER NOT NULL REFERENCES vol(id) ON DELETE CASCADE,
    siege_id INTEGER NOT NULL REFERENCES siege(id) ON DELETE CASCADE,
    est_promotion BOOLEAN DEFAULT FALSE,
    taux_promotion DECIMAL(5, 2) DEFAULT 0 CHECK (taux_promotion >= 0 AND taux_promotion <= 100),
    prix_base DECIMAL(10, 2) NOT NULL CHECK (prix_base >= 0),
    prix_final DECIMAL(10, 2) NOT NULL CHECK (prix_final >= 0),
    est_disponible BOOLEAN DEFAULT TRUE, -- TRUE = Disponible, FALSE = Réservé
    UNIQUE(vol_id, siege_id)
);

CREATE TABLE promotion_vol (
    id SERIAL PRIMARY KEY,
    vol_id INTEGER REFERENCES vol(id),
    type_siege_id INTEGER REFERENCES type_siege(id),
    taux_promotion DECIMAL(5, 2) NOT NULL, 
    date_debut TIMESTAMP NOT NULL,
    date_fin TIMESTAMP NOT NULL,
    est_active BOOLEAN DEFAULT TRUE, -- TRUE = Disponible, FALSE = Fin promo 
    nbr_siege_promo INT NOT NULL ,
    UNIQUE(vol_id, type_siege_id)
);

CREATE EXTENSION IF NOT EXISTS pgcrypto;
CREATE TABLE utilisateur (
    id SERIAL PRIMARY KEY,
    email VARCHAR(100) NOT NULL UNIQUE,
    mot_de_passe VARCHAR(255) NOT NULL,
    nom VARCHAR(100) NOT NULL,
    prenom VARCHAR(100) NOT NULL,
    date_naissance DATE,
    telephone VARCHAR(20),
    role VARCHAR(20) NOT NULL,
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE reservation (
    id SERIAL PRIMARY KEY,
    utilisateur_id INTEGER NOT NULL REFERENCES utilisateur(id) ON DELETE CASCADE,
    vol_id INTEGER NOT NULL REFERENCES vol(id) ON DELETE CASCADE,
   -- date_reservation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    date_reservation TIMESTAMP NOT NULL,
    statut BOOLEAN DEFAULT TRUE, 
    nombre_passager INTEGER DEFAULT 0 CHECK (nombre_passager >= 0),
    montant_total DECIMAL(10, 2) NOT NULL CHECK (montant_total >= 0) DEFAULT 0,
    is_payer INT DEFAULT 0
);
    
CREATE TABLE passager (
    id SERIAL PRIMARY KEY,
    reservation_id INTEGER NOT NULL REFERENCES reservation(id) ON DELETE CASCADE,
    nom VARCHAR(100) NOT NULL,
    prenom VARCHAR(100) NOT NULL,
    date_naissance DATE NOT NULL,
    passeport_file_data VARCHAR(100) NOT NULL
);

CREATE TABLE detail_reservation (
    id SERIAL PRIMARY KEY,
    reservation_id INTEGER NOT NULL REFERENCES reservation(id) ON DELETE CASCADE,
    siege_vol_id INTEGER NOT NULL REFERENCES siege_vol(id) ON DELETE CASCADE,
    prix_unitaire DECIMAL(10, 2) NOT NULL CHECK (prix_unitaire >= 0) DEFAULT 0,
    passager_id INTEGER REFERENCES passager(id) ON DELETE cascade,
    UNIQUE(reservation_id, siege_vol_id)
);

CREATE TABLE regle_reservation (
    id SERIAL PRIMARY KEY,
    heures_avant_vol INTEGER NOT NULL, 
    active BOOLEAN DEFAULT TRUE
);

CREATE TABLE regle_annulation (
    id SERIAL PRIMARY KEY,
    heures_apres_reservation INTEGER NOT NULL, 
    active BOOLEAN DEFAULT TRUE
);

CREATE TABLE regle_prix (
    id SERIAL PRIMARY KEY,
    age_min INTEGER not null,
    age_max INTEGER not null,
    pourcentage_prix DECIMAL(10,2)
);


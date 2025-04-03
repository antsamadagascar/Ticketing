
# ✈️ Fonctionnalités – Application Ticketing

## 📌 Présentation générale

**Nom de l'application** : Ticketing  
**Langage** : Java  
**Framework Web** : Framework maison basé sur Spring  
**Base de données** : PostgreSQL  

---

## 🗂 I. Backoffice (Administrateur)

### 🔐 Authentification
- Connexion sécurisée par identifiant / mot de passe.

### 🛫 Gestion des Vols
- Création, modification, suppression des vols.
- Recherche de vols selon différents critères (ville de départ, date, etc.).

### ⚙️ Paramétrage des règles métier
- **Promotion par vol** :
  - Définir un pourcentage de sièges en promotion selon les types (Business, Éco...).
- **Règle de réservation** :
  - Nombre d’heures minimum avant le départ pour autoriser une réservation.
- **Règle d’annulation** :
  - Délai maximum autorisé pour annuler une réservation après sa création.

---

## 🌐 II. Frontoffice (Utilisateur)

### 🔎 Recherche de vols
- Recherche par ville, date, type de siège...

### 📝 Réservation de vol
- Sélection de sièges selon le vol.
- Saisie des informations passager (nom, prénom, date de naissance).
- Upload du passeport (format fichier).
- Calcul automatique du prix selon :
  - Type de siège (Business, Éco, Premium)
  - Réduction selon l’âge (ex : -20% pour enfants de 1 à 13 ans).

---

## 🛠 III. Base de Données (Vue simplifiée)

| Entité       | Attributs principaux                                              |
|--------------|--------------------------------------------------------------------|
| `Avion`      | id, modèle, nb sièges (éco/business), date de fabrication         |
| `Ville`      | id, nom                                                            |
| `Vol`        | id, date, ville départ, ville arrivée, avion                       |
| `TypeSiege`  | id, libellé, tarif                                                 |
| `Siege`      | id, type, vol, numéro                                              |
| `Utilisateur`| id, email, mot de passe, rôle                                      |
| `Reservation`| id, utilisateur, passagers, sièges                                 |
| `ReglePrix`  | tranche âge, pourcentage de réduction                              |

---

## 🎯 Exemple de scénario métier : Réservation

Un utilisateur connecté réserve un vol pour 5 personnes :

- **2 adultes** : sièges Business à 800$ chacun → 2 × 800 = **1600$**
- **3 enfants** :
  - 3 sièges Éco à 180$ → avec -20% = 144$ chacun → 3 × 144 = **432$**
  - 1 siège Premium à 350$ → avec -20% = **280$**

### ➕ Total :
- Total adultes : 1600$  
- Total enfants : 432$ + 280$ = **712$**  
- **Total global : 2312$**

---

## 📋 Côté Affichage

- Liste dynamique des vols disponibles.
- Affichage des sièges disponibles sous forme de checkbox avec numéro.
- Génération dynamique des formulaires passagers selon les sièges sélectionnés.

## 🧠 Côté Métier

- Méthode `creerReservation` modifiée pour :
  - Gérer le nombre de passagers.
  - Calculer dynamiquement le montant total en fonction du nombre d’adultes/enfants et des règles de prix.

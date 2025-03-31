package dao;

import java.math.BigDecimal;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import models.*;
import utils.connection.PostgresConnection;

public class VolMulticritereDAO {
    private Connection connection;

    public VolMulticritereDAO() {
        this.connection = PostgresConnection.getConnection();
    }

    /**
     * Recherche multicritère de vols basée sur la vue SQL.
     *
     * @param villeDepart      Ville de départ
     * @param villeArrivee     Ville d'arrivée
     * @param dateDepart       Date de départ
     * @param typeSiege        Type de siège (Économique, Affaires, etc.)
     * @param nombrePassagers  Nombre de passagers
     * @return Liste des vols correspondants
     */
    public List<VolMulticritereResult> rechercherVols(Ville villeDepart, Ville villeArrivee,
                                                  LocalDateTime dateDepart, TypeSiege typeSiege,
                                                  BigDecimal prixMin, BigDecimal prixMax,
                                                  int nombrePassagers) {
    List<VolMulticritereResult> resultats = new ArrayList<>();

    String sql = "SELECT * FROM rechercher_vols(?, ?, ?, ?, ?, ?, ?)";

    try (PreparedStatement statement = connection.prepareStatement(sql)) {
        // Définir les paramètres de la fonction
        statement.setInt(1, villeDepart != null ? villeDepart.getId() : null);
        statement.setInt(2, villeArrivee != null ? villeArrivee.getId() : null);
        statement.setTimestamp(3, dateDepart != null ? Timestamp.valueOf(dateDepart) : null);
        statement.setInt(4, typeSiege != null ? typeSiege.getId() : null);
        statement.setBigDecimal(5, prixMin);
        statement.setBigDecimal(6, prixMax);
        statement.setInt(7, nombrePassagers);

        // Exécuter la requête
        ResultSet resultSet = statement.executeQuery();

        // Parcourir les résultats
        while (resultSet.next()) {
            // Créer les objets Ville avec les noms retournés par la fonction
            Ville villeDep = new Ville();
            villeDep.setId(villeDepart != null ? villeDepart.getId() : null);
            villeDep.setNom(resultSet.getString("ville_depart_nom")); // Nom de la ville de départ

            Ville villeArr = new Ville();
            villeArr.setId(villeArrivee != null ? villeArrivee.getId() : null);
            villeArr.setNom(resultSet.getString("ville_arrivee_nom")); // Nom de la ville d'arrivée

             TypeSiege typeSiegeVol = new TypeSiege();
            typeSiegeVol.setId(typeSiege != null ? typeSiege.getId() : null);
            typeSiegeVol.setNom(resultSet.getString("type_siege_nom")); // Nom du type de siège

            Avion avion = new Avion();

            // Créer un objet VolMulticritereResult
            VolMulticritereResult vol = new VolMulticritereResult(
                resultSet.getInt("vol_id"),
                resultSet.getString("numero_vol"),
                villeDep, 
                villeArr, 
                resultSet.getTimestamp("date_depart").toLocalDateTime(),
                resultSet.getTimestamp("date_arrivee").toLocalDateTime(),
                avion,
                typeSiegeVol,
                resultSet.getInt("sieges_disponibles"),
                resultSet.getDouble("prix_final"), 
                resultSet.getDouble("prix_final"), 
                resultSet.getBoolean("est_promotion"),
                0.0 
            );
            resultats.add(vol);
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }

    return resultats;
}
 public static void main(String[] args) {
        // Créer les objets nécessaires pour la recherche
        Ville paris = new Ville();
        paris.setId(1); // ID de Paris dans la base de données
        paris.setNom("Paris");

        Ville newYork = new Ville();
        newYork.setId(2); // ID de New York dans la base de données
        newYork.setNom("New York");

        TypeSiege economique = new TypeSiege();
        economique.setId(1); // ID du type de siège "Économique"
        economique.setNom("Économique");

        LocalDateTime dateDepart = LocalDateTime.of(2023, 12, 1, 0, 0); // Date de départ
        BigDecimal prixMin = new BigDecimal("100.00"); // Prix minimum
        BigDecimal prixMax = new BigDecimal("500.00"); // Prix maximum
        int nombrePassagers = 1; // Nombre de passagers

        // Créer une instance du DAO (assurez-vous d'avoir une connexion valide)
        Connection connection = PostgresConnection.getConnection(); // À adapter selon votre gestion de connexion
        VolMulticritereDAO volDAO = new VolMulticritereDAO();

        // Exécuter la recherche
        List<VolMulticritereResult> vols = volDAO.rechercherVols(
            paris, newYork, dateDepart, economique, prixMin, prixMax, nombrePassagers
        );

        // Afficher les résultats
        if (vols.isEmpty()) {
            System.out.println("Aucun vol trouvé pour les critères spécifiés.");
        } else {
            System.out.println("Vols trouvés :");
            for (VolMulticritereResult vol : vols) {
                System.out.println("----------------------------------------");
                System.out.println("Vol ID: " + vol.getVolId());
                System.out.println("Numéro de vol: " + vol.getNumeroVol());
                System.out.println("Ville de départ: " + vol.getVilleDepart().getNom());
                System.out.println("Ville d'arrivée: " + vol.getVilleArrivee().getNom());
                System.out.println("Date de départ: " + vol.getDateDepart());
                System.out.println("Date d'arrivée: " + vol.getDateArrivee());
                System.out.println("Modèle d'avion: " + vol.getAvion().getModele());
                System.out.println("Type de siège: " + vol.getTypeSiege().getNom());
                System.out.println("Nombre de sièges disponibles: " + vol.getNombreSiegesDisponibles());
                System.out.println("Prix minimum: " + vol.getPrixMinimum());
                System.out.println("Prix maximum: " + vol.getPrixMaximum());
                System.out.println("En promotion: " + (vol.isEstEnPromotion() ? "Oui" : "Non"));
                System.out.println("Taux de promotion: " + vol.getTauxPromotion() + "%");
            }
        }
    }
    }

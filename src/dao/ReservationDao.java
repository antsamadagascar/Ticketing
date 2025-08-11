package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import models.Passager;
import models.Reservation;
import models.Utilisateur;
import models.Vol;
import utils.connection.PostgresConnection;

public class ReservationDao {
    public List<Reservation> getAll() {
        List<Reservation> reservations = new ArrayList<>();
        String query = "SELECT * FROM view_reservations_passagers";

        try (Connection conn = PostgresConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Reservation reservation = new Reservation();
                reservation.setId(rs.getInt("reservation_id"));
                reservation.setMontantTotal(rs.getDouble("montant_total"));
                reservation.setDateReservation(rs.getTimestamp("date_reservation"));
                reservation.setStatut(rs.getBoolean("statut_reservation"));
                reservation.setIsPayer(rs.getInt("is_payer"));
                
                Utilisateur utilisateur = new Utilisateur();
                utilisateur.setId(rs.getInt("id"));
                utilisateur.setNom(rs.getString("nom_passager"));
                utilisateur.setPrenom(rs.getString("prenom_passager"));
                utilisateur.setEmail(rs.getString("email_passager"));
                reservation.setUtilisateur(utilisateur);
                
                Vol vol = new Vol();
                vol.setNumeroVol(rs.getString("numero_vol"));
                vol.setDateDepart(rs.getTimestamp("date_depart"));
                vol.setDateArrivee(rs.getTimestamp("date_arrivee"));
                reservation.setVol(vol);
                
                reservations.add(reservation);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return reservations;
    }

    public List<Reservation> getByIdUser(int userId) {
        List<Reservation> reservations = new ArrayList<>();
        String query = "SELECT * FROM view_reservations_passagers WHERE id = ?";

        try (Connection conn = PostgresConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Reservation reservation = new Reservation();
                    reservation.setId(rs.getInt("reservation_id"));
                    reservation.setMontantTotal(rs.getDouble("montant_total"));
                    reservation.setDateReservation(rs.getTimestamp("date_reservation"));
                    reservation.setStatut(rs.getBoolean("statut_reservation"));
                    reservation.setNombrePassager(rs.getInt("nombre_passager"));
                    reservation.setIsPayer(rs.getInt("is_payer"));

                    Utilisateur utilisateur = new Utilisateur();
                    utilisateur.setId(rs.getInt("id"));
                    utilisateur.setNom(rs.getString("nom_passager"));
                    utilisateur.setPrenom(rs.getString("prenom_passager"));
                    utilisateur.setEmail(rs.getString("email_passager"));
                    reservation.setUtilisateur(utilisateur);
                    
                    Vol vol = new Vol();
                    vol.setId(rs.getInt("volId"));
                    vol.setNumeroVol(rs.getString("numero_vol"));
                    vol.setDateDepart(rs.getTimestamp("date_depart"));
                    vol.setDateArrivee(rs.getTimestamp("date_arrivee"));
                    reservation.setVol(vol);
                    
                    reservations.add(reservation);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return reservations;
    }
    
    public boolean annulerReservation(int reservationId, int userId) throws SQLException {
        String query = "UPDATE reservation SET statut = FALSE WHERE id = ? AND utilisateur_id = ?";
        
        try (Connection connection = PostgresConnection.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(query)) {
             
            preparedStatement.setInt(1, reservationId);
            preparedStatement.setInt(2, userId);
            int rowsUpdated = preparedStatement.executeUpdate();
            
            return rowsUpdated > 0;
        }
    }

    // Méthode pour effectuer un reservation et qui retourne les passagers avec leurs IDs
    public List<Passager> creerReservation(int idUtilisateur, int idVol, Timestamp dateReservation, 
                                        List<Passager> passagers, List<Integer> siegeIds) throws SQLException {
        String sqlReservation = "INSERT INTO reservation (utilisateur_id, vol_id,date_reservation,nombre_passager) VALUES (?,?, ?, ?) RETURNING id";
        String sqlDetails = "INSERT INTO detail_reservation (reservation_id, siege_vol_id, passager_id) VALUES (?, ?, ?)";
        
        try (Connection connection = PostgresConnection.getConnection()) {
            connection.setAutoCommit(false);
            PassagerDao passagerDao = new PassagerDao(connection);
            
            try (PreparedStatement stmtReservation = connection.prepareStatement(sqlReservation)) {
                stmtReservation.setInt(1, idUtilisateur);
                stmtReservation.setInt(2, idVol);
                stmtReservation.setTimestamp(3, dateReservation);            
                stmtReservation.setInt(4, passagers.size());
                
                System.out.println(">> Requête RESERVATION : " +
                    "INSERT INTO reservation (utilisateur_id, vol_id,date_reservation,nombre_passager) VALUES (" +
                    idUtilisateur + ", " + idVol + ", " + dateReservation +",  " + passagers.size() + ")");
                
                ResultSet rs = stmtReservation.executeQuery();
                if (!rs.next()) {
                    throw new SQLException("Échec de la création de la réservation, aucun ID retourné");
                }
                int reservationId = rs.getInt("id");
                
                // Liste pour stocker les passagers avec leurs vrais IDs
                List<Passager> passagersAvecIds = new ArrayList<>();
                List<Integer> passagerIds = new ArrayList<>();
                
                // Crée les passagers et construire la liste avec les vrais IDs
                for (Passager passager : passagers) {
                    int passagerId = passagerDao.creerPassager(
                        reservationId,
                        passager.getNom(),
                        passager.getPrenom(),
                        passager.getDateNaissance(),
                        passager.getPasseportFileName()
                    );
                    passagerIds.add(passagerId);
                    
                    // Crée un nouveau passager avec l'ID réel
                    Passager passagerAvecId = new Passager(
                        passagerId, 
                        reservationId, 
                        passager.getNom(), 
                        passager.getPrenom(), 
                        passager.getDateNaissance(), 
                        passager.getPasseportFileName()
                    );
                    passagersAvecIds.add(passagerAvecId);
                    
                    System.out.println(">> Requête PASSAGER : " +
                        "INSERT INTO passager (reservation_id, nom, prenom, date_naissance, passeport) VALUES (" +
                        reservationId + ", '" + passager.getNom() + "', '" + passager.getPrenom() + "', '" +
                        passager.getDateNaissance() + "', '" + passager.getPasseportFileName() + "')");
                }
                
                // Crée les détails de réservation
                try (PreparedStatement stmtDetails = connection.prepareStatement(sqlDetails)) {
                    for (int i = 0; i < siegeIds.size(); i++) {
                        stmtDetails.setInt(1, reservationId);
                        stmtDetails.setInt(2, siegeIds.get(i));
                        stmtDetails.setInt(3, passagerIds.get(i));
                        
                        System.out.println(">> Requête DETAIL : " +
                            "INSERT INTO detail_reservation (reservation_id, siege_vol_id, passager_id) VALUES (" +
                            reservationId + ", " + siegeIds.get(i) + ", " + passagerIds.get(i) + ")");
                        
                        stmtDetails.executeUpdate();
                    }
                }
                
                connection.commit();
                return passagersAvecIds; // Retourne les passagers avec leurs  IDs
                
            } catch (SQLException e) {
                connection.rollback();
                e.printStackTrace();
                throw e;
            }
        }
    }

    public int getNextReservationId() throws SQLException {
        String sql = "SELECT nextval('reservation_id_seq')"; 
        try (Connection connection = PostgresConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet resultSet = statement.executeQuery()) {
            if (resultSet.next()) {
                return resultSet.getInt(1); 
            }
        }
        throw new SQLException("Impossible de générer un ID de réservation");
    }

    public int getHeuresAnnulation() throws SQLException {
        String sql = "SELECT heures_apres_reservation FROM regle_annulation WHERE active = TRUE LIMIT 1";
        try (Connection conn = PostgresConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt("heures_apres_reservation");
            }
            return 1; 
        }
    }

    public int getHeuresReservation() throws SQLException {
        String sql = "SELECT heures_avant_vol FROM regle_reservation WHERE active = TRUE";
        try (Connection conn = PostgresConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt("heures_avant_vol");
            }
            return 1; 
        }
    }

    public List<Passager> getPassagersParReservation(int reservationId) throws SQLException {
        List<Passager> passagers = new ArrayList<>();
        String sql = "SELECT * FROM passager WHERE reservation_id = ?";
        
        try (Connection conn = PostgresConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
             
            stmt.setInt(1, reservationId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Passager p = new Passager();
                    p.setId(rs.getInt("id"));
                    p.setNom(rs.getString("nom"));
                    p.setPrenom(rs.getString("prenom"));
                    p.setDateNaissance(rs.getDate("date_naissance"));
                    p.setPasseportFileName(rs.getString("passeport_file_data"));
                    passagers.add(p);
                }
            }
        }
    
        return passagers;
    }    

    public String getPasseportFilePath(int reservationId) throws SQLException {
        String sql = "SELECT p.passeport_file_data, r.utilisateur_id, r.vol_id " +
                    "FROM passager p " +
                    "JOIN reservation r ON p.reservation_id = r.id " +
                    "WHERE r.id = ? LIMIT 1";
        
        try (Connection conn = PostgresConnection.getConnection();
            PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, reservationId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    String fileName = rs.getString("passeport_file_data");
                    int userId = rs.getInt("utilisateur_id");
                    int volId = rs.getInt("vol_id");
                    
                    if (fileName != null && !fileName.isEmpty()) {
                        String basePath = "C:\\Program Files\\Apache Software Foundation\\Tomcat 10.1\\webapps\\data_reservation_ticketing\\";
                        return basePath + "utilisateur_" + userId + 
                            "\\vol_" + volId + 
                            "\\reservation_" + reservationId + 
                            "\\" + fileName;
                    }
                }
            }
        }
        
        return null;
    }
    
}


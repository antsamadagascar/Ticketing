package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import models.Reservation;
import models.Utilisateur;
import models.Vol;
import other.FileUpload;
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
                    String basePath = "/Ticketing/upload/utilisateur_" + userId + "/vol_" + rs.getInt("volId") + "/reservation_" + rs.getInt("reservation_id") + "/";
                    String fileName = rs.getString("passeport_file_data");

                    if (fileName != null && !fileName.isEmpty()) {
                        FileUpload passeport = new FileUpload();
                        passeport.setFilePath(basePath + fileName);
                        reservation.setPassFileUpload(passeport);
                    }

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
    public int creerReservation(int idUtilisateur, int idVol, int idSiege, int nombrePassagers, String nomPasseport) throws SQLException {
        String sqlReservation = "INSERT INTO reservation (utilisateur_id, vol_id, nombre_passager, passeport_file_data) VALUES (?, ?, ?, ?) RETURNING id";
        String sqlDetails = "INSERT INTO detail_reservation (reservation_id, siege_vol_id) VALUES (?, ?)";
    
        try (Connection connection = PostgresConnection.getConnection();
             PreparedStatement stmtReservation = connection.prepareStatement(sqlReservation);
             PreparedStatement stmtDetails = connection.prepareStatement(sqlDetails)) {
    
            connection.setAutoCommit(false);
    
            stmtReservation.setInt(1, idUtilisateur);
            stmtReservation.setInt(2, idVol);
            stmtReservation.setInt(3, nombrePassagers);
            stmtReservation.setString(4, nomPasseport);
            ResultSet rs = stmtReservation.executeQuery();
    
            if (rs.next()) {
                int reservationId = rs.getInt("id");
    
                stmtDetails.setInt(1, reservationId);
                stmtDetails.setInt(2, idSiege);
                stmtDetails.executeUpdate();
    
                connection.commit();
                return reservationId; // Retourne l'ID de la réservation
            }
    
            throw new SQLException("Échec de la création de la réservation, aucun ID retourné");
        } catch (SQLException e) {
            e.printStackTrace();
            throw e;
        }
    }
    public String getPasseportFilePath(int reservationId) throws SQLException {
        String sql = "SELECT passeport_file_path FROM reservation WHERE id = ?";
        try (Connection connection = PostgresConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, reservationId);
            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    return resultSet.getString("passeport_file_path");
                }
            }
        }
        return null; // Retourne null si aucun fichier n'est trouvé
    }
    public int getNextReservationId() throws SQLException {
        String sql = "SELECT nextval('reservation_id_seq')"; // Utilisez le nom de votre séquence PostgreSQL
        try (Connection connection = PostgresConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet resultSet = statement.executeQuery()) {
            if (resultSet.next()) {
                return resultSet.getInt(1); // Retourne la valeur suivante de la séquence
            }
        }
        throw new SQLException("Impossible de générer un ID de réservation");
    }
}

package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import models.Passager;
import utils.connection.PostgresConnection;
import java.util.logging.Logger;

public class PassagerDao {

    private Connection connection;
    private static final Logger logger = Logger.getLogger(PassagerDao.class.getName());

    public PassagerDao() {
        this.connection = PostgresConnection.getConnection();
    }

    public PassagerDao(Connection connection) {
        this.connection = connection;
    }

    public int creerPassager(int reservationId, String nom, String prenom, Date dateNaissance, String passeportFileName) throws SQLException {
        logger.info("Création du passager avec les données : reservationId=" + reservationId + ", nom=" + nom + ", prenom=" + prenom + 
                    ", dateNaissance=" + dateNaissance + ", passeportFileName=" + passeportFileName);
    
        String query = "INSERT INTO passager (reservation_id, nom, prenom, date_naissance, passeport_file_data) " +
                       "VALUES (?, ?, ?, ?, ?) RETURNING id";
        try (PreparedStatement pstmt = connection.prepareStatement(query)) {
            pstmt.setInt(1, reservationId);
            pstmt.setString(2, nom);
            pstmt.setString(3, prenom);
            pstmt.setDate(4, new java.sql.Date(dateNaissance.getTime()));
            pstmt.setString(5, passeportFileName);
    
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                int passagerId = rs.getInt("id");
                logger.info("Création du passager réussie avec id=" + passagerId);
                return passagerId;
            } else {
                throw new SQLException("La création du passager a échoué, aucun ID généré.");
            }
        }
    }
    public Passager getById(int id) throws SQLException {
        String query = "SELECT * FROM passager WHERE id = ?";

        try (PreparedStatement pstmt = connection.prepareStatement(query)) {
            pstmt.setInt(1, id);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                return mapResultSetToPassager(rs);
            }
        }

        return null;
    }

    public List<Passager> getByReservationId(int reservationId) throws SQLException {
        List<Passager> passagers = new ArrayList<>();
        String query = "SELECT * FROM passager WHERE reservation_id = ?";

        try (PreparedStatement pstmt = connection.prepareStatement(query)) {
            pstmt.setInt(1, reservationId);
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                passagers.add(mapResultSetToPassager(rs));
            }
        }

        return passagers;
    }

    public String getPasseportFilePath(int passagerId) throws SQLException {
        String query = "SELECT p.passeport_file_data, r.id as reservation_id, r.vol_id, r.utilisateur_id " +
                       "FROM passager p " +
                       "JOIN reservation r ON p.reservation_id = r.id " +
                       "WHERE p.id = ?";

        try (PreparedStatement pstmt = connection.prepareStatement(query)) {
            pstmt.setInt(1, passagerId);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                int utilisateurId = rs.getInt("utilisateur_id");
                int volId = rs.getInt("vol_id");
                int reservationId = rs.getInt("reservation_id");
                String fileName = rs.getString("passeport_file_data");

                return String.format("C:\\Program Files\\Apache Software Foundation\\Tomcat 10.1\\webapps\\Ticketing\\upload\\utilisateur_%d\\vol_%d\\reservation_%d\\passager_%d\\%s",
                        utilisateurId, volId, reservationId, passagerId, fileName);
            }
        }

        return null;
    }

    public boolean supprimer(int passagerId) throws SQLException {
        String query = "DELETE FROM passager WHERE id = ?";

        try (PreparedStatement pstmt = connection.prepareStatement(query)) {
            pstmt.setInt(1, passagerId);
            return pstmt.executeUpdate() > 0;
        }
    }

    private Passager mapResultSetToPassager(ResultSet rs) throws SQLException {
        Passager passager = new Passager();
        passager.setId(rs.getInt("id"));
        passager.setReservationId(rs.getInt("reservation_id"));
        passager.setNom(rs.getString("nom"));
        passager.setPrenom(rs.getString("prenom"));
        passager.setDateNaissance(rs.getDate("date_naissance"));
        passager.setPasseportFileName(rs.getString("passeport_file_data"));
        return passager;
    }
}

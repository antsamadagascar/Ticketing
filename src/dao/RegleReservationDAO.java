package dao;

import models.RegleReservation;
import utils.connection.PostgresConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class RegleReservationDAO {

    public List<RegleReservation> getAll() {
        List<RegleReservation> regles = new ArrayList<>();
        String query = "SELECT * FROM regle_reservation";

        try (Connection conn = PostgresConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {
            
            while (rs.next()) {
                RegleReservation regle = new RegleReservation();
                regle.setId(rs.getInt("id"));
                regle.setHeuresAvantVol(rs.getInt("heures_avant_vol"));
                regle.setActive(rs.getBoolean("active"));
                regles.add(regle);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return regles;
    }
    
    public void add(RegleReservation regle) throws SQLException {
        String query = "INSERT INTO regle_reservation (heures_avant_vol, active) VALUES (?, ?)";
        try (Connection conn = PostgresConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, regle.getHeuresAvantVol());
            stmt.setBoolean(2, regle.isActive());
            stmt.executeUpdate();
        }
    }

    public void update(RegleReservation regle) throws SQLException {
        String query = "UPDATE regle_reservation SET heures_avant_vol = ?, active = ? WHERE id = ?";
        try (Connection conn = PostgresConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, regle.getHeuresAvantVol());
            stmt.setBoolean(2, regle.isActive());
            stmt.setInt(3, regle.getId());
            stmt.executeUpdate();
        }
    }
}

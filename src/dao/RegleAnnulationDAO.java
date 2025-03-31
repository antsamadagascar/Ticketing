package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import models.RegleAnnulation;
import utils.connection.PostgresConnection;

public class RegleAnnulationDAO {

    public List<RegleAnnulation> getAll()  {
        List<RegleAnnulation> regles = new ArrayList<>();
        String query = "SELECT * FROM regle_annulation";
        try (Connection conn = PostgresConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {
            while (rs.next()) {
                RegleAnnulation regle = new RegleAnnulation();
                regle.setId(rs.getInt("id"));
                regle.setHeuresApresReservation(rs.getInt("heures_apres_reservation"));
                regle.setActive(rs.getBoolean("active"));
                regles.add(regle);
            }
            
        }
        catch (SQLException e) {
            e.printStackTrace(); 
        }
        return regles;
    }
    
    public void add(RegleAnnulation regle) throws SQLException {
        String query = "INSERT INTO regle_annulation (heures_apres_reservation, active) VALUES (?, ?)";
        try (Connection conn = PostgresConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, regle.getHeuresApresReservation());
            stmt.setBoolean(2, regle.isActive());
            stmt.executeUpdate();
        }
    }

    public void update(RegleAnnulation regle) throws SQLException {
        String query = "UPDATE regle_annulation SET heures_apres_reservation = ?, active = ? WHERE id = ?";
        try (Connection conn = PostgresConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, regle.getHeuresApresReservation());
            stmt.setBoolean(2, regle.isActive());
            stmt.setInt(3, regle.getId());
            stmt.executeUpdate();
        }
    }
}
package dao;

import models.Avion;
import utils.connection.PostgresConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class AvionDao {
    public List<Avion> getAll() {
        List<Avion> avions = new ArrayList<>();
        String query = "SELECT * FROM avion";

        try (Connection conn = PostgresConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Avion avion = new Avion();
                avion.setId(rs.getInt("id"));
                avion.setModele(rs.getString("modele"));
                avions.add(avion);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return avions;
    }
}

package dao;

import models.Ville;
import utils.connection.PostgresConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class VilleDao {
    public List<Ville> getAll() {
        List<Ville> villes = new ArrayList<>();
        String query = "SELECT * FROM ville";

        try (Connection conn = PostgresConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Ville ville = new Ville();
                ville.setId(rs.getInt("id"));
                ville.setNom(rs.getString("nom"));
                villes.add(ville);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return villes;
    }
}

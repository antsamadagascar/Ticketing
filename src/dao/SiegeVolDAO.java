package  dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import models.SiegeVol;
import utils.connection.PostgresConnection;

public class SiegeVolDAO {
    private Connection connection;

    public SiegeVolDAO(Connection connection) {
        this.connection = PostgresConnection.getConnection();
    }

    public List<SiegeVol> getSiegesDisponiblesParVol(int volId) {
        List<SiegeVol> sieges = new ArrayList<>();
        String sql = """
            SELECT sv.id AS siege_vol_id, s.numero AS numero_siege, ts.nom AS type_siege, sv.prix_final
            FROM siege_vol sv
            JOIN siege s ON sv.siege_id = s.id
            JOIN avion_type_siege ats ON s.avion_type_siege_id = ats.id
            JOIN type_siege ts ON ats.type_siege_id = ts.id
            WHERE sv.vol_id = ? AND sv.est_disponible = TRUE;
        """;

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, volId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                SiegeVol siege = new SiegeVol();
                siege.setId(rs.getInt("siege_vol_id"));
                siege.setNumero(rs.getString("numero_siege"));
                siege.setType(rs.getString("type_siege"));
                siege.setPrix(rs.getDouble("prix_final"));
                
                sieges.add(siege);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return sieges;
    }

    public static void main(String[] args) {
        try {
            Connection connection = PostgresConnection.getConnection();
            SiegeVolDAO siegeVolDAO = new SiegeVolDAO(connection);

            int volId = 1; // ID du vol sélectionné
            List<SiegeVol> sieges = siegeVolDAO.getSiegesDisponiblesParVol(volId);

            System.out.println("Sièges disponibles pour le vol " + volId + " :");
            for (SiegeVol siege : sieges) {
                System.out.println(siege);
            }

            connection.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}

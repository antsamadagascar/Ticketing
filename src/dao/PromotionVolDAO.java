package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import models.PromotionVol;
import models.TypeSiege;
import models.Vol;
import utils.connection.PostgresConnection;

public class PromotionVolDAO {

    public List<PromotionVol> getAll() {
        List<PromotionVol> promotions = new ArrayList<>();
        String query = "SELECT pv.id, v.id AS vol_id, v.numero_vol, ts.id AS type_siege_id, ts.nom, pv.taux_promotion, pv.date_debut, pv.date_fin, pv.est_active " +
            "FROM promotion_vol pv " +
            "JOIN vol v ON pv.vol_id = v.id " +
            "JOIN type_siege ts ON pv.type_siege_id = ts.id";

        
        try (Connection connection = PostgresConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(query);
             ResultSet rs = statement.executeQuery()) {
            
            while (rs.next()) {
                PromotionVol promotion = new PromotionVol();
                promotion.setId(rs.getInt("id"));
                
                Vol vol = new Vol();
                vol.setId(rs.getInt("vol_id"));
                vol.setNumeroVol(rs.getString("numero_vol"));
                promotion.setVol(vol);
                
                TypeSiege typeSiege = new TypeSiege();
                typeSiege.setId(rs.getInt("type_siege_id"));
                typeSiege.setNom(rs.getString("nom"));
                promotion.setTypeSiege(typeSiege);
                
                promotion.setTauxPromotion(rs.getDouble("taux_promotion"));
                promotion.setDateDebut(rs.getTimestamp("date_debut"));
                promotion.setDateFin(rs.getTimestamp("date_fin"));
                promotion.setEstActive(rs.getBoolean("est_active"));

                
                promotions.add(promotion);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return promotions;
    }
    
    public void add(PromotionVol promotionVol) {
        String query = "INSERT INTO promotion_vol (vol_id, type_siege_id, taux_promotion, date_debut, date_fin) VALUES (?, ?, ?, ?, ?)";
        try (Connection connection = PostgresConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(query)) {
            statement.setInt(1, promotionVol.getVol().getId());
            statement.setInt(2, promotionVol.getTypeSiege().getId());
            statement.setDouble(3, promotionVol.getTauxPromotion());
            statement.setTimestamp(4, promotionVol.getDateDebut());
            statement.setTimestamp(5, promotionVol.getDateFin());
            statement.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void update(PromotionVol promotionVol) {
        String query = "UPDATE promotion_vol SET vol_id = ?, type_siege_id = ?, taux_promotion = ?, date_debut = ?, date_fin = ?, est_active = ? WHERE id = ?";
        try (Connection connection = PostgresConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(query)) {
            statement.setInt(1, promotionVol.getVol().getId());
            statement.setInt(2, promotionVol.getTypeSiege().getId());
            statement.setDouble(3, promotionVol.getTauxPromotion());
            statement.setTimestamp(4, promotionVol.getDateDebut());
            statement.setTimestamp(5, promotionVol.getDateFin());
            statement.setBoolean(6, promotionVol.isEstActive());
            statement.setInt(7, promotionVol.getId());
            statement.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}

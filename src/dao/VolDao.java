package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import models.Avion;
import models.Ville;
import models.Vol;
import utils.connection.PostgresConnection;

public class VolDao {
    public List<Vol> getAll() {
        List<Vol> vols = new ArrayList<>();
        String query = "SELECT v.id, v.numero_vol, vd.id AS ville_depart_id, vd.nom AS ville_depart_nom, va.id AS ville_arrivee_id, va.nom AS ville_arrivee_nom, v.date_depart, v.date_arrivee, a.id AS avion_id, a.modele, v.statut FROM vol v JOIN ville vd ON v.ville_depart_id = vd.id JOIN ville va ON v.ville_arrivee_id = va.id JOIN avion a ON v.avion_id = a.id";
        
        try (Connection conn = PostgresConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {
            while (rs.next()) {
                Vol vol = new Vol();
                vol.setId(rs.getInt("id"));
                vol.setNumeroVol(rs.getString("numero_vol"));
                
                Ville villeDepart = new Ville();
                villeDepart.setId(rs.getInt("ville_depart_id"));
                villeDepart.setNom(rs.getString("ville_depart_nom"));
                vol.setVilleDepart(villeDepart);
                
                Ville villeArrivee = new Ville();
                villeArrivee.setId(rs.getInt("ville_arrivee_id"));
                villeArrivee.setNom(rs.getString("ville_arrivee_nom"));
                vol.setVilleArrivee(villeArrivee);
                
                vol.setDateDepart(rs.getTimestamp("date_depart"));
                vol.setDateArrivee(rs.getTimestamp("date_arrivee"));
                
                Avion avion = new Avion();
                avion.setId(rs.getInt("avion_id"));
                avion.setModele(rs.getString("modele"));
                vol.setAvion(avion);
                
                vol.setStatut(rs.getInt("statut"));
                
                vols.add(vol);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return vols;
    }

    public Vol findById(int id) {
        Vol vol = null;
        String sql = "SELECT * FROM vol WHERE id = ?";
        
        try (Connection connection = PostgresConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            
            statement.setInt(1, id);
            ResultSet resultSet = statement.executeQuery();
            
            if (resultSet.next()) {
                vol = new Vol();
                vol.setId(resultSet.getInt("id"));
                vol.setNumeroVol(resultSet.getString("numero_vol"));
                vol.setDateDepart(resultSet.getTimestamp("date_depart"));
                vol.setDateArrivee(resultSet.getTimestamp("date_arrivee"));
                vol.setStatut(resultSet.getInt("statut"));
    
                Ville villeDepart = new Ville();
                villeDepart.setId(resultSet.getInt("ville_depart_id"));
                vol.setVilleDepart(villeDepart);
    
                Ville villeArrivee = new Ville();
                villeArrivee.setId(resultSet.getInt("ville_arrivee_id"));
                vol.setVilleArrivee(villeArrivee);
    
                Avion avion = new Avion();
                avion.setId(resultSet.getInt("avion_id"));
                vol.setAvion(avion);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return vol;
    }
    
    public void add(Vol vol) {
        try (Connection conn = PostgresConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement("INSERT INTO vol (numero_vol, ville_depart_id, ville_arrivee_id, date_depart, date_arrivee, avion_id, statut) VALUES (?, ?, ?, ?, ?, ?, ?)", Statement.RETURN_GENERATED_KEYS)) {
            stmt.setString(1, vol.getNumeroVol());
            stmt.setInt(2, vol.getVilleDepart().getId());
            stmt.setInt(3, vol.getVilleArrivee().getId());
            stmt.setTimestamp(4, new Timestamp(vol.getDateDepart().getTime()));
            stmt.setTimestamp(5, new Timestamp(vol.getDateArrivee().getTime()));
            stmt.setInt(6, vol.getAvion().getId());
            stmt.setInt(7, vol.getStatut());
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void update(Vol vol) {
        try (Connection conn = PostgresConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement("UPDATE vol SET numero_vol=?, ville_depart_id=?, ville_arrivee_id=?, date_depart=?, date_arrivee=?, avion_id=?, statut=? WHERE id=?")) {
            stmt.setString(1, vol.getNumeroVol());
            stmt.setInt(2, vol.getVilleDepart().getId());
            stmt.setInt(3, vol.getVilleArrivee().getId());
            stmt.setTimestamp(4, new Timestamp(vol.getDateDepart().getTime()));
            stmt.setTimestamp(5, new Timestamp(vol.getDateArrivee().getTime()));
            stmt.setInt(6, vol.getAvion().getId());
            stmt.setInt(7, vol.getStatut());
            stmt.setInt(8, vol.getId());
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void delete(int id) {
        try (Connection conn = PostgresConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement("DELETE FROM vol WHERE id=?")) {
            stmt.setInt(1, id);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public static void main(String[] args) {
        VolDao volDao = new VolDao();

        // Test de récupération de tous les vols
        List<Vol> vols = volDao.getAll();
        System.out.println("Liste des vols :");
        for (Vol vol : vols) {
            System.out.println("Statut vol: " + vol.getStatut());
        }


    }
}

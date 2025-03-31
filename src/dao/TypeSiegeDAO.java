package dao;

import models.TypeSiege;
import utils.connection.PostgresConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class TypeSiegeDAO {
    private Connection connection;

    public TypeSiegeDAO() {
        this.connection = PostgresConnection.getConnection();
    }

    public List<TypeSiege> getAll() {
        List<TypeSiege> typesSiege = new ArrayList<>();
        String sql = "SELECT * FROM type_siege";
        
        try (Statement statement = connection.createStatement();
             ResultSet resultSet = statement.executeQuery(sql)) {
            while (resultSet.next()) {
                TypeSiege type = new TypeSiege();
                type.setId(resultSet.getInt("id"));
                type.setNom(resultSet.getString("nom"));
                typesSiege.add(type);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return typesSiege;
    }

    public TypeSiege findById(int id) {
        String sql = "SELECT * FROM type_siege WHERE id = ?";
        
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, id);
            ResultSet resultSet = statement.executeQuery();
            
            if (resultSet.next()) {
                TypeSiege type = new TypeSiege();
                type.setId(resultSet.getInt("id"));
                type.setNom(resultSet.getString("nom"));
                return type;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }
}

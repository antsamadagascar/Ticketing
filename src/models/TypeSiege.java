package models;

public class TypeSiege {
    private int id;
    private String nom;
    private String description;
    private double tarifBase;

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getNom() { return nom; }
    public void setNom(String nom) { this.nom = nom; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public double getTarifBase() { return tarifBase; }
    public void setTarifBase(double tarifBase) { this.tarifBase = tarifBase; }
}

package models;

public class AvionTypeSiege {
    private int id;
    private Avion avion;
    private TypeSiege typeSiege;
    private int nombreSieges;

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public Avion getAvion() { return avion; }
    public void setAvion(Avion avion) { this.avion = avion; }
    public TypeSiege getTypeSiege() { return typeSiege; }
    public void setTypeSiege(TypeSiege typeSiege) { this.typeSiege = typeSiege; }
    public int getNombreSieges() { return nombreSieges; }
    public void setNombreSieges(int nombreSieges) { this.nombreSieges = nombreSieges; }
}

package models;

public class Siege {
    private int id;
    private String numero;
    private AvionTypeSiege avionTypeSiege;
    private boolean disponible;

    // Constructors
    public Siege() {
    }

    public Siege(int id, String numero, AvionTypeSiege avionTypeSiege, boolean disponible) {
        this.id = id;
        this.numero = numero;
        this.avionTypeSiege = avionTypeSiege;
        this.disponible = disponible;
    }

    // Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getNumero() {
        return numero;
    }

    public void setNumero(String numero) {
        this.numero = numero;
    }

    public AvionTypeSiege getAvionTypeSiege() {
        return avionTypeSiege;
    }

    public void setAvionTypeSiege(AvionTypeSiege avionTypeSiege) {
        this.avionTypeSiege = avionTypeSiege;
    }

    public boolean isDisponible() {
        return disponible;
    }

    public void setDisponible(boolean disponible) {
        this.disponible = disponible;
    }

    @Override
    public String toString() {
        return "Siege{" +
                "id=" + id +
                ", numero='" + numero + '\'' +
                ", avionTypeSiege=" + (avionTypeSiege != null ? avionTypeSiege.getId() : "null") +
                ", disponible=" + disponible +
                '}';
    }
}
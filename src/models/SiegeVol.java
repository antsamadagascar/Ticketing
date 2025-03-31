package models;

public class SiegeVol {
    private int id;
    private String numero;
    private String type;
    private double prix;

    public SiegeVol() {
        // Constructeur vide
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getNumero() { return numero; }
    public void setNumero(String numero) { this.numero = numero; }

    public String getType() { return type; }
    public void setType(String type) { this.type = type; }

    public double getPrix() { return prix; }
    public void setPrix(double prix) { this.prix = prix; }

    @Override
    public String toString() {
        return "Siège " + numero + " - " + type + " - " + prix + "€";
    }
}
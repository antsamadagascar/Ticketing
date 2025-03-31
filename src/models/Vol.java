package models;

import java.util.Date;

public class Vol {
    private int id;

    private String numeroVol;

    private Ville villeDepart;

    private Ville villeArrivee;

    private Date dateDepart;

    private Date dateArrivee;

    private Avion avion;

    private Integer statut;

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getNumeroVol() { return numeroVol; }
    public void setNumeroVol(String numeroVol) { this.numeroVol = numeroVol; }
    public Ville getVilleDepart() { return villeDepart; }
    public void setVilleDepart(Ville villeDepart) { this.villeDepart = villeDepart; }
    public Ville getVilleArrivee() { return villeArrivee; }
    public void setVilleArrivee(Ville villeArrivee) { this.villeArrivee = villeArrivee; }
    public Date getDateDepart() { return dateDepart; }
    public void setDateDepart(Date dateDepart) { this.dateDepart = dateDepart; }
    public Date getDateArrivee() { return dateArrivee; }
    public void setDateArrivee(Date dateArrivee) { this.dateArrivee = dateArrivee; }
    public Avion getAvion() { return avion; }
    public void setAvion(Avion avion) { this.avion = avion; }
    public Integer getStatut() {
        return statut;
    }
    
    public void setStatut(int statut) {
        this.statut = statut;
    }
}
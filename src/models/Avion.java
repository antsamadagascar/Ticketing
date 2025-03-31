package models;

import java.util.Date;
import java.util.List;

public class Avion {
    private int id;
    private String modele;
    private Date dateFabrication;
    private List<Vol> vols;

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getModele() { return modele; }
    public void setModele(String modele) { this.modele = modele; }
    public Date getDateFabrication() { return dateFabrication; }
    public void setDateFabrication(Date dateFabrication) { this.dateFabrication = dateFabrication; }
}
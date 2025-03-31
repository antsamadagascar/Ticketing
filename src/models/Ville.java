
package models;

import java.util.List;

public class Ville {
    private int id;
    private String nom;
    private String codeAeroport;
    private String pays;
    private String fuseauHoraire;
    private List<Vol> volsDepart;
    private List<Vol> volsArrivee;

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getNom() { return nom; }
    public void setNom(String nom) { this.nom = nom; }
    public String getCodeAeroport() { return codeAeroport; }
    public void setCodeAeroport(String codeAeroport) { this.codeAeroport = codeAeroport; }
    public String getPays() { return pays; }
    public void setPays(String pays) { this.pays = pays; }
    public String getFuseauHoraire() { return fuseauHoraire; }
    public void setFuseauHoraire(String fuseauHoraire) { this.fuseauHoraire = fuseauHoraire; }
}
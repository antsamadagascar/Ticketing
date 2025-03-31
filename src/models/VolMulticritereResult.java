package models;

import java.time.LocalDateTime;

public class VolMulticritereResult {
    private int volId;
    private String numeroVol;
    private Ville villeDepart;
    private Ville villeArrivee;
    private LocalDateTime dateDepart;
    private LocalDateTime dateArrivee;
    private Avion avion;
    private TypeSiege typeSiege;
    private int nombreSiegesDisponibles;
    private double prixMinimum;
    private double prixMaximum;
    private boolean estEnPromotion;
    private double tauxPromotion;

    // Constructeur par défaut
    public VolMulticritereResult() {}

    // Constructeur avec tous les paramètres
    public VolMulticritereResult(int volId, String numeroVol, Ville villeDepart, Ville villeArrivee,
                                 LocalDateTime dateDepart, LocalDateTime dateArrivee, Avion avion,
                                 TypeSiege typeSiege, int nombreSiegesDisponibles, double prixMinimum,
                                 double prixMaximum, boolean estEnPromotion, double tauxPromotion) {
        this.volId = volId;
        this.numeroVol = numeroVol;
        this.villeDepart = villeDepart;
        this.villeArrivee = villeArrivee;
        this.dateDepart = dateDepart;
        this.dateArrivee = dateArrivee;
        this.avion = avion;
        this.typeSiege = typeSiege;
        this.nombreSiegesDisponibles = nombreSiegesDisponibles;
        this.prixMinimum = prixMinimum;
        this.prixMaximum = prixMaximum;
        this.estEnPromotion = estEnPromotion;
        this.tauxPromotion = tauxPromotion;
    }

    // Getters et setters pour chaque attribut

    public int getVolId() {
        return volId;
    }

    public void setVolId(int volId) {
        this.volId = volId;
    }

    public String getNumeroVol() {
        return numeroVol;
    }

    public void setNumeroVol(String numeroVol) {
        this.numeroVol = numeroVol;
    }

    public Ville getVilleDepart() {
        return villeDepart;
    }

    public void setVilleDepart(Ville villeDepart) {
        this.villeDepart = villeDepart;
    }

    public Ville getVilleArrivee() {
        return villeArrivee;
    }

    public void setVilleArrivee(Ville villeArrivee) {
        this.villeArrivee = villeArrivee;
    }

    public LocalDateTime getDateDepart() {
        return dateDepart;
    }

    public void setDateDepart(LocalDateTime dateDepart) {
        this.dateDepart = dateDepart;
    }

    public LocalDateTime getDateArrivee() {
        return dateArrivee;
    }

    public void setDateArrivee(LocalDateTime dateArrivee) {
        this.dateArrivee = dateArrivee;
    }

    public Avion getAvion() {
        return avion;
    }

    public void setAvion(Avion avion) {
        this.avion = avion;
    }

    public TypeSiege getTypeSiege() {
        return typeSiege;
    }

    public void setTypeSiege(TypeSiege typeSiege) {
        this.typeSiege = typeSiege;
    }

    public int getNombreSiegesDisponibles() {
        return nombreSiegesDisponibles;
    }

    public void setNombreSiegesDisponibles(int nombreSiegesDisponibles) {
        this.nombreSiegesDisponibles = nombreSiegesDisponibles;
    }

    public double getPrixMinimum() {
        return prixMinimum;
    }

    public void setPrixMinimum(double prixMinimum) {
        this.prixMinimum = prixMinimum;
    }

    public double getPrixMaximum() {
        return prixMaximum;
    }

    public void setPrixMaximum(double prixMaximum) {
        this.prixMaximum = prixMaximum;
    }

    public boolean isEstEnPromotion() {
        return estEnPromotion;
    }

    public void setEstEnPromotion(boolean estEnPromotion) {
        this.estEnPromotion = estEnPromotion;
    }

    public double getTauxPromotion() {
        return tauxPromotion;
    }

    public void setTauxPromotion(double tauxPromotion) {
        this.tauxPromotion = tauxPromotion;
    }

    // Méthode toString pour afficher les détails de l'objet
    @Override
    public String toString() {
        return "VolMulticritereResult{" +
                "volId=" + volId +
                ", numeroVol='" + numeroVol + '\'' +
                ", villeDepart=" + villeDepart.getNom() +
                ", villeArrivee=" + villeArrivee.getNom() +
                ", dateDepart=" + dateDepart +
                ", dateArrivee=" + dateArrivee +
                ", avion=" + avion.getModele() +
                ", typeSiege=" + typeSiege.getNom() +
                ", nombreSiegesDisponibles=" + nombreSiegesDisponibles +
                ", prixMinimum=" + prixMinimum +
                ", prixMaximum=" + prixMaximum +
                ", estEnPromotion=" + estEnPromotion +
                ", tauxPromotion=" + tauxPromotion +
                '}';
    }
}
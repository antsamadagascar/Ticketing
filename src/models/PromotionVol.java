package models;

import java.sql.Timestamp;

public class PromotionVol {
    private int id;
    private Vol vol;
    private TypeSiege typeSiege;
    private int pourcentageSieges;
    private double tauxPromotion;
    private Timestamp dateDebut;
    private Timestamp dateFin;
    private boolean estActive; 
    private int nbrSiegePromo;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public Vol getVol() {
        return vol;
    }

    public void setVol(Vol vol) {
        this.vol = vol;
    }

    public TypeSiege getTypeSiege() {
        return typeSiege;
    }

    public void setTypeSiege(TypeSiege typeSiege) {
        this.typeSiege = typeSiege;
    }

    public int getPourcentageSieges() {
        return pourcentageSieges;
    }

    public void setPourcentageSieges(int pourcentageSieges) {
        this.pourcentageSieges = pourcentageSieges;
    }

    public double getTauxPromotion() {
        return tauxPromotion;
    }

    public void setTauxPromotion(double tauxPromotion) {
        this.tauxPromotion = tauxPromotion;
    }

    public Timestamp getDateDebut() {
        return dateDebut;
    }

    public void setDateDebut(Timestamp dateDebut) {
        this.dateDebut = dateDebut;
    }

    public Timestamp getDateFin() {
        return dateFin;
    }

    public void setDateFin(Timestamp dateFin) {
        this.dateFin = dateFin;
    }
    
    public boolean isEstActive() {
        return estActive;
    }
    
    public void setEstActive(boolean estActive) {
        this.estActive = estActive;
    }

    public void setReduction(double reduction) {
        // TODO Auto-generated method stub
        throw new UnsupportedOperationException("Unimplemented method 'setReduction'");
    }

    public void setNbrSiegePromo(int nbrSiegePromo) {
        this.nbrSiegePromo = nbrSiegePromo;
    }

    public int getNbrSiegePromo() {
        return nbrSiegePromo;
    }
}

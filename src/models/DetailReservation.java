package models;

public class DetailReservation {
    private int id;
    private Reservation reservation;
    private int siegeVolId;
    private Double prixUnitaire;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public Reservation getReservation() {
        return reservation;
    }

    public void setReservation(Reservation reservation) {
        this.reservation = reservation;
    }

    public int getSiegeVolId() {
        return siegeVolId;
    }

    public void setSiegeVolId(int siegeVolId) {
        this.siegeVolId = siegeVolId;
    }

    public Double getPrixUnitaire() {
        return prixUnitaire;
    }

    public void setPrixUnitaire(Double prixUnitaire) {
        this.prixUnitaire = prixUnitaire;
    }
}

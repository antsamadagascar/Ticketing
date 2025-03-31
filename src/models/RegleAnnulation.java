package models;

public class RegleAnnulation {
    private int id;
    private int heuresApresReservation;
    private boolean active;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getHeuresApresReservation() {
        return heuresApresReservation;
    }

    public void setHeuresApresReservation(int heuresApresReservation) {
        this.heuresApresReservation = heuresApresReservation;
    }

    public boolean isActive() {
        return active;
    }

    public void setActive(boolean active) {
        this.active = active;
    }
}
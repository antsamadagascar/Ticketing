package models;

public class RegleReservation {
    private int id;
    private int heuresAvantVol;
    private boolean active;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getHeuresAvantVol() {
        return heuresAvantVol;
    }

    public void setHeuresAvantVol(int heuresAvantVol) {
        this.heuresAvantVol = heuresAvantVol;
    }

    public boolean isActive() {
        return active;
    }

    public void setActive(boolean active) {
        this.active = active;
    }
}
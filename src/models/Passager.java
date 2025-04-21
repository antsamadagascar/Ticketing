package models;

import java.util.Date;

import com.fasterxml.jackson.annotation.JsonProperty;

public class Passager {
    private int id;
    private int reservationId;
    private String nom;
    private String prenom;
    private Date dateNaissance;
    
    @JsonProperty("passeport") 
    private String passeportFileName;


    public Passager() {
    }

    public Passager(int id, int reservationId, String nom, String prenom, Date dateNaissance, String passeportFileName) {
        this.id = id;
        this.reservationId = reservationId;
        this.nom = nom;
        this.prenom = prenom;
        this.dateNaissance = dateNaissance;
        this.passeportFileName = passeportFileName;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getReservationId() {
        return reservationId;
    }

    public void setReservationId(int reservationId) {
        this.reservationId = reservationId;
    }

    public String getNom() {
        return nom;
    }

    public void setNom(String nom) {
        this.nom = nom;
    }

    public String getPrenom() {
        return prenom;
    }

    public void setPrenom(String prenom) {
        this.prenom = prenom;
    }

    public Date getDateNaissance() {
        return dateNaissance;
    }

    public void setDateNaissance(Date dateNaissance) {
        this.dateNaissance = dateNaissance;
    }

    public String getPasseportFileName() {
        return passeportFileName;
    }

    public void setPasseportFileName(String passeportFileName) {
        this.passeportFileName = passeportFileName;
    }

    public int getAge() {
        if (this.dateNaissance == null) {
            return 0;
        }
        long ageInMillis = new Date().getTime() - this.dateNaissance.getTime();
        return (int)(ageInMillis / (1000L * 60 * 60 * 24 * 365));
    }

    @Override
    public String toString() {
        return "Passager{" +
                "id=" + id +
                ", reservationId=" + reservationId +
                ", nom='" + nom + '\'' +
                ", prenom='" + prenom + '\'' +
                ", dateNaissance=" + dateNaissance +
                ", passeport='" + passeportFileName + '\'' +
                '}';
    }
}

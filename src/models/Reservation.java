package models;

import java.sql.Timestamp;
import java.util.List;

import mg.itu.nyantsa.other.FileUpload;

public class Reservation {
    private int id;
    private Utilisateur utilisateur;
    private Vol vol;
    private Timestamp dateReservation;
    private boolean statut;
    private int nombrePassager;
    private Double montantTotal;
    private FileUpload passFileUpload;
    private List<Passager> passagers;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public Utilisateur getUtilisateur() {
        return utilisateur;
    }

    public void setUtilisateur(Utilisateur utilisateur) {
        this.utilisateur = utilisateur;
    }

    public Vol getVol() {
        return vol;
    }

    public void setVol(Vol vol) {
        this.vol = vol;
    }

    public Timestamp getDateReservation() {
        return dateReservation;
    }

    public void setDateReservation(Timestamp dateReservation) {
        this.dateReservation = dateReservation;
    }

    public boolean isStatut() {
        return statut;
    }

    public void setStatut(boolean statut) {
        this.statut = statut;
    }

    public int getNombrePassager() {
        return nombrePassager;
    }

    public void setNombrePassager(int nombrePassager) {
        this.nombrePassager = nombrePassager;
    }

    public Double getMontantTotal() {
        return montantTotal;
    }

    public void setMontantTotal(Double montantTotal) {
        this.montantTotal = montantTotal;
    }

    public FileUpload getPassFileUpload() {
         return passFileUpload;
    }

     public void setPassFileUpload(FileUpload passFileUpload) {
         this.passFileUpload = passFileUpload;
     }

     public List<Passager> getPassagers() {
        return passagers;
    }
    
    public void setPassagers(List<Passager> passagers) {
        this.passagers = passagers;
    }
}



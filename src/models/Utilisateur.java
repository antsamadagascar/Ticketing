package models;

import java.sql.Date;
import mg.itu.nyantsa.annotation.ValidateForm.*;

public class Utilisateur {
   // @ValidNumber(min = 1, positiveOnly = true)
    private int id;
    
    @NotNull(message = "L'email est obligatoire")
    @ValidEmail(message = "Format d'email invalide")
    private String email;
    
    @NotNull(message = "Le mot de passe est obligatoire")
    @Length(min = 6, max = 50, message = "Le mot de passe doit contenir entre 6 et 50 caractères")
    private String motDePasse;
    
 // @NotNull(message = "Le nom est obligatoire")
//@Length(min = 2, max = 50, message = "Le nom doit contenir entre 2 et 50 caractères")
    private String nom;
    
  //  @NotNull(message = "Le prénom est obligatoire")
  //  @Length(min = 2, max = 50, message = "Le prénom doit contenir entre 2 et 50 caractères")
    private String prenom;
    
 //   @NotNull(message = "La date de naissance est obligatoire")
    private Date dateNaissance;
    
  //  @Length(min = 10, max = 10, message = "Le numéro de téléphone doit contenir exactement 10 caractères")
    private String telephone;
    
   // @NotNull(message = "Le rôle est obligatoire")
    private String role;
    
    private Date dateCreation;
    
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getMotDePasse() {
        return motDePasse;
    }

    public void setMotDePasse(String motDePasse) {
        this.motDePasse = motDePasse;
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

    public String getTelephone() {
        return telephone;
    }

    public void setTelephone(String telephone) {
        this.telephone = telephone;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public Date getDateCreation() {
        return dateCreation;
    }

    public void setDateCreation(Date dateCreation) {
        this.dateCreation = dateCreation;
    }
}

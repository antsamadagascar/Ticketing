package controller;

import dao.AvionDao;
import dao.VilleDao;
import dao.VolDao;
import models.Avion;
import models.Ville;
import models.Vol;
import other.ModelView;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import annotation.Controller;
import annotation.Param;
import annotation.methods.Get;
import annotation.methods.Post;
import annotation.methods.Url;
import exception.ValidationError;
import annotation.ValidateForm;
import annotation.auth.Authentification;

@Controller("VolController")
@Authentification("manager") 
public class VolController {
    private VolDao volDao = new VolDao();
    private AvionDao avionDao = new AvionDao();
    private VilleDao villeDao = new VilleDao();
    private static final ValidateForm validator = new ValidateForm();
    
    private List<Vol> vols = volDao.getAll();
    private List<Avion> avions = avionDao.getAll();
    private List<Ville> villes = villeDao.getAll();
    @Url("/vols")
    @Get
    public ModelView getAllVols() {
        ModelView mv = new ModelView();
        
        mv.add("vols", vols);
        mv.add("avions", avions);
        mv.add("villes", villes);
        mv.setUrl("/WEB-INF/pages/admin/template-admin.jsp");
        mv.add("pageContent", "/WEB-INF/pages/vol/vols.jsp");

        return mv;
    }

    @Url("/vols/add")
    @Post
    public ModelView addVol(
        @Param(name = "numeroVol") String numeroVol,
        @Param(name = "villeDepartId") int villeDepartId,
        @Param(name = "villeArriveeId") int villeArriveeId,
        @Param(name = "dateDepart") String dateDepart,
        @Param(name = "dateArrivee") String dateArrivee,
        @Param(name = "avionId") int avionId,
        @Param(name = "statut") int statut
    ) {
        ModelView mv = new ModelView();
        ValidationError validationError = new ValidationError();

        if (numeroVol == null || numeroVol.trim().isEmpty()) {
            validationError.addError("numeroVol", "Le numéro de vol est obligatoire");
        } else if (numeroVol.length() < 3 || numeroVol.length() > 10) {
            validationError.addError("numeroVol", "Le numéro de vol doit contenir entre 3 et 10 caractères");
        }
                
        Date dDepart = null;
        Date dArrivee = null;
        SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
        
        if (dateDepart == null || dateDepart.trim().isEmpty()) {
            validationError.addError("dateDepart", "La date de départ est obligatoire");
        } else {
            try {
                dDepart = format.parse(dateDepart);
            } catch (ParseException e) {
                validationError.addError("dateDepart", "Format de date de départ invalide");
            }
        }
        
        if (dateArrivee == null || dateArrivee.trim().isEmpty()) {
            validationError.addError("dateArrivee", "La date d'arrivée est obligatoire");
        } else {
            try {
                dArrivee = format.parse(dateArrivee);
            } catch (ParseException e) {
                validationError.addError("dateArrivee", "Format de date d'arrivée invalide");
            }
        }

        if (dDepart != null && dArrivee != null && dArrivee.before(dDepart)) {
            validationError.addError("dateArrivee", "La date d'arrivée doit être postérieure à la date de départ");
        }
        
        if (villeDepartId == villeArriveeId) {
            validationError.addError("villeArriveeId", "La ville d'arrivée doit être différente de la ville de départ");
        }
        
        if (validationError.hasErrors()) {
            List<Ville> villes = villeDao.getAll();
            List<Avion> avions = avionDao.getAll();
            List<Vol> vols = volDao.getAll();

            mv.add("numeroVol", numeroVol);
            mv.add("villeDepartId", villeDepartId);
            mv.add("villeArriveeId", villeArriveeId);
            mv.add("dateDepart", dateDepart);
            mv.add("dateArrivee", dateArrivee);
            mv.add("avionId", avionId);
            mv.add("statut", statut);
     
            validationError.getFieldErrors().forEach((field, error) -> {
                mv.add(field + "Error", error);
            });
            
            mv.add("vols", vols);
            mv.add("avions", avions);
            mv.add("villes", villes);
            mv.setUrl("/WEB-INF/pages/admin/template-admin.jsp");
            mv.add("pageContent", "/WEB-INF/pages/vol/vols.jsp");
            return mv;
        }
        
        Vol vol = new Vol();
        vol.setNumeroVol(numeroVol);
        vol.setDateDepart(dDepart);
        vol.setDateArrivee(dArrivee);
        vol.setStatut(statut);

        Ville villeDepart = new Ville();
        villeDepart.setId(villeDepartId);
        vol.setVilleDepart(villeDepart);

        Ville villeArrivee = new Ville();
        villeArrivee.setId(villeArriveeId);
        vol.setVilleArrivee(villeArrivee);

        Avion avion = new Avion();
        avion.setId(avionId);
        vol.setAvion(avion);

        volDao.add(vol);
        mv.add("successMessage", "Le vol a été ajouté avec succès !");
        
        mv.add("vols", vols);
        mv.add("avions", avions);
        mv.add("villes", villes);
        mv.setUrl("/WEB-INF/pages/admin/template-admin.jsp");
        mv.add("pageContent", "/WEB-INF/pages/vol/vols.jsp");

        return mv;
    }

    @Url("/vols/edit")
    @Get
    public ModelView editVol(@Param(name = "id") int id) {
        ModelView mv = new ModelView();

        Vol vol = volDao.findById(id);
        List<Ville> villes = villeDao.getAll();
        List<Avion> avions = avionDao.getAll();

        mv.setUrl("/WEB-INF/pages/admin/template-admin.jsp");
        mv.add("pageContent", "/WEB-INF/pages/vol/edit-vol.jsp");
        mv.add("vol", vol);
        mv.add("villes", villes);
        mv.add("avions", avions);

        return mv;
    }

    @Url("/vols/update")
    @Post
    public ModelView updateVol(
        @Param(name = "id") int id,
        @Param(name = "numeroVol") String numeroVol,
        @Param(name = "villeDepartId") int villeDepartId,
        @Param(name = "villeArriveeId") int villeArriveeId,
        @Param(name = "dateDepart") String dateDepart,
        @Param(name = "dateArrivee") String dateArrivee,
        @Param(name = "avionId") int avionId,
        @Param(name = "statut") int statut
    ) {
        ModelView mv = new ModelView();
        ValidationError validationError = new ValidationError();
        

        if (numeroVol == null || numeroVol.trim().isEmpty()) {
            validationError.addError("numeroVol", "Le numéro de vol est obligatoire");
        } else if (numeroVol.length() < 3 || numeroVol.length() > 10) {
            validationError.addError("numeroVol", "Le numéro de vol doit contenir entre 3 et 10 caractères");
        }
                
        // Validation des dates
        Date dDepart = null;
        Date dArrivee = null;
        SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
        
        if (dateDepart == null || dateDepart.trim().isEmpty()) {
            validationError.addError("dateDepart", "La date de départ est obligatoire");
        } else {
            try {
                dDepart = format.parse(dateDepart);
            } catch (ParseException e) {
                validationError.addError("dateDepart", "Format de date de départ invalide");
            }
        }
        
        if (dateArrivee == null || dateArrivee.trim().isEmpty()) {
            validationError.addError("dateArrivee", "La date d'arrivée est obligatoire");
        } else {
            try {
                dArrivee = format.parse(dateArrivee);
            } catch (ParseException e) {
                validationError.addError("dateArrivee", "Format de date d'arrivée invalide");
            }
        }
        
        // Vérification que la date d'arrivée est après la date de départ
        if (dDepart != null && dArrivee != null && dArrivee.before(dDepart)) {
            validationError.addError("dateArrivee", "La date d'arrivée doit être postérieure à la date de départ");
        }
        
        // Vérification que les villes de départ et d'arrivée sont différentes
        if (villeDepartId == villeArriveeId) {
            validationError.addError("villeArriveeId", "La ville d'arrivée doit être différente de la ville de départ");
        }
        
        // Si des erreurs de validation sont présentes
        if (validationError.hasErrors()) {
            // Préparation de la vue d'erreur
            List<Ville> villes = villeDao.getAll();
            List<Avion> avions = avionDao.getAll();
            
            // Récréer un objet Vol pour l'affichage
            Vol vol = new Vol();
            vol.setId(id);
            vol.setNumeroVol(numeroVol);
            vol.setStatut(statut);
            
            Ville villeDepart = new Ville();
            villeDepart.setId(villeDepartId);
            vol.setVilleDepart(villeDepart);
            
            Ville villeArrivee = new Ville();
            villeArrivee.setId(villeArriveeId);
            vol.setVilleArrivee(villeArrivee);
            
            Avion avion = new Avion();
            avion.setId(avionId);
            vol.setAvion(avion);
            
            // Conserver les dates sous forme de chaîne pour l'affichage
            mv.add("dateDepart", dateDepart);
            mv.add("dateArrivee", dateArrivee);
            
            // Ajouter les erreurs de validation
            validationError.getFieldErrors().forEach((field, error) -> {
                mv.add(field + "Error", error);
            });
            
            // Configuration de la vue
            mv.add("vol", vol);
            mv.add("villes", villes);
            mv.add("avions", avions);
            mv.setUrl("/WEB-INF/pages/admin/template-admin.jsp");
            mv.add("pageContent", "/WEB-INF/pages/vol/edit-vol.jsp");
            
            return mv;
        }
        
        // Si tout est valide, procéder à la mise à jour
        Vol vol = volDao.findById(id);
        vol.setNumeroVol(numeroVol);
        vol.setDateDepart(dDepart);
        vol.setDateArrivee(dArrivee);
        vol.setStatut(statut);

        vol.getVilleDepart().setId(villeDepartId);
        vol.getVilleArrivee().setId(villeArriveeId);
        vol.getAvion().setId(avionId);
        mv.add("successMessage", "Le vol a été mis à jour avec succès !");
        mv.add("vols", vols);
        mv.add("avions", avions);
        mv.add("villes", villes);

        volDao.update(vol);
        
        mv.setUrl("/WEB-INF/pages/admin/template-admin.jsp");
        mv.add("pageContent", "/WEB-INF/pages/vol/vols.jsp");
  
        return mv;
    }

    @Url("/vols/delete")
    @Get
    public ModelView deleteVol(@Param(name = "id") int id) {
        volDao.delete(id);
        return getAllVols();
    }
}
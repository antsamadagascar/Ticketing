package controller;

import dao.RegleAnnulationDAO;
import exception.ValidationError;
import models.RegleAnnulation;
import other.ModelView;

import java.sql.SQLException;
import java.util.List;
import java.util.Optional;

import annotation.Controller;
import annotation.Param;
import annotation.auth.Authentification;
import annotation.methods.Get;
import annotation.methods.Post;
import annotation.methods.Url;

@Controller("RegleAnnulationController")
@Authentification("manager") 
public class RegleAnnulationController {
    private RegleAnnulationDAO regleAnnulationDao = new RegleAnnulationDAO();

    @Url("/regles-annulation")
    @Get
    public ModelView getAllReglesAnnulation() {
        ModelView mv = new ModelView();
        List<RegleAnnulation> regles = regleAnnulationDao.getAll();
        
        mv.add("regles", regles);
        mv.setUrl("/WEB-INF/pages/admin/template-admin.jsp");
        mv.add("pageContent", "/WEB-INF/pages/annulation/annulations.jsp");
        
        return mv;
    }

    @Url("/regles-annulation/add")
    @Post
    public ModelView addRegleAnnulation(
        @Param(name = "heuresApresReservation") String heuresApresReservationStr,
        @Param(name = "active") String activeStr
    ) throws SQLException {
        ModelView mv = new ModelView();
        ValidationError validationError = new ValidationError();

        Integer heuresApresReservation = null;
        Boolean active = null;

        if (heuresApresReservationStr == null || heuresApresReservationStr.trim().isEmpty()) {
            validationError.addError("heuresApresReservation", "Le champ 'Heures après réservation' est obligatoire.");
        } else {
            try {
                heuresApresReservation = Integer.parseInt(heuresApresReservationStr);
                if (heuresApresReservation <= 0) {
                    validationError.addError("heuresApresReservation", "Le nombre d'heures doit être supérieur à 0.");
                }
            } catch (NumberFormatException e) {
                validationError.addError("heuresApresReservation", "Le format du champ 'Heures après réservation' est invalide.");
            }
        }

        if (activeStr == null || activeStr.trim().isEmpty()) {
            validationError.addError("active", "Le champ 'Active' est obligatoire.");
        } else {
            active = Boolean.parseBoolean(activeStr);
        }

        if (validationError.hasErrors()) {
            mv.add("errors", validationError.getFieldErrors());
            mv.add("heuresApresReservation", heuresApresReservationStr);
            mv.add("active", activeStr);
            mv.setUrl("/WEB-INF/pages/admin/template-admin.jsp");
            mv.add("pageContent", "/WEB-INF/pages/annulation/annulations.jsp");
            return mv;
        }

        RegleAnnulation regle = new RegleAnnulation();
        regle.setHeuresApresReservation(heuresApresReservation);
        regle.setActive(active);
        
        regleAnnulationDao.add(regle);

        mv = getAllReglesAnnulation();
        mv.add("successMessage", "La règle d'annulation a été ajoutée avec succès !");
        return mv;
    }

    @Url("/regles-annulation/edit")
    @Get
    public ModelView editRegleAnnulation(@Param(name = "id") int id) {
        final int regleId = id; 
    
        ModelView mv = new ModelView();
        List<RegleAnnulation> regles = regleAnnulationDao.getAll();
        
        Optional<RegleAnnulation> regle = regles.stream().filter(r -> r.getId() == regleId).findFirst();
        
        if (regle.isPresent()) {
            mv.add("regle", regle.get());
        }
        
        mv.setUrl("/WEB-INF/pages/admin/template-admin.jsp");
        mv.add("pageContent", "/WEB-INF/pages/annulation/edit-annulation.jsp");
        
        return mv;
    }
    
    @Url("/regles-annulation/update")
    @Post
    public ModelView updateRegleAnnulation(
        @Param(name = "id") String idStr,
        @Param(name = "heuresApresReservation") String heuresApresReservationStr,
        @Param(name = "active") String activeStr
    ) throws SQLException {
        ModelView mv = new ModelView();
        ValidationError validationError = new ValidationError();
    
        Integer id = null;
        Integer heuresApresReservation = null;
        Boolean active = null;
    
        if (idStr == null || idStr.trim().isEmpty()) {
            validationError.addError("id", "L'identifiant est requis.");
        } else {
            try {
                id = Integer.parseInt(idStr);
            } catch (NumberFormatException e) {
                validationError.addError("id", "L'identifiant est invalide.");
            }
        }
    
        if (heuresApresReservationStr == null || heuresApresReservationStr.trim().isEmpty()) {
            validationError.addError("heuresApresReservation", "Le champ 'Heures après réservation' est obligatoire.");
        } else {
            try {
                heuresApresReservation = Integer.parseInt(heuresApresReservationStr);
                if (heuresApresReservation <= 0) {
                    validationError.addError("heuresApresReservation", "Le nombre d'heures doit être supérieur à 0.");
                }
            } catch (NumberFormatException e) {
                validationError.addError("heuresApresReservation", "Le format du champ 'Heures après réservation' est invalide.");
            }
        }
    
        if (activeStr == null || activeStr.trim().isEmpty()) {
            validationError.addError("active", "Le champ 'Active' est obligatoire.");
        } else {
            active = Boolean.parseBoolean(activeStr);
        }
    
        if (id != null) {
            List<RegleAnnulation> regles = regleAnnulationDao.getAll();
            final int finalId = id; // Variable finale pour éviter l'erreur dans la lambda
            Optional<RegleAnnulation> regle = regles.stream().filter(r -> r.getId() == finalId).findFirst();
    
            if (regle.isEmpty()) {
                validationError.addError("id", "Règle d'annulation introuvable.");
            }
    
            if (validationError.hasErrors()) {
                mv.add("errors", validationError.getFieldErrors());
                mv.add("id", idStr);
                mv.add("heuresApresReservation", heuresApresReservationStr);
                mv.add("active", activeStr);
                mv.setUrl("/WEB-INF/pages/admin/template-admin.jsp");
                mv.add("pageContent", "/WEB-INF/pages/annulation/edit-annulation.jsp");
                return mv;
            }
            
            RegleAnnulation updatedRegle = regle.get();
            updatedRegle.setHeuresApresReservation(heuresApresReservation);
            updatedRegle.setActive(active);
            regleAnnulationDao.update(updatedRegle);
    
            mv = getAllReglesAnnulation();
            mv.add("successMessage", "La règle d'annulation a été mise à jour avec succès !");
        } else {
            mv.add("errors", validationError.getFieldErrors());
            mv.add("id", idStr);
            mv.add("heuresApresReservation", heuresApresReservationStr);
            mv.add("active", activeStr);
            mv.setUrl("/WEB-INF/pages/admin/template-admin.jsp");
            mv.add("pageContent", "/WEB-INF/pages/annulation/edit-annulation.jsp");
        }
    
        return mv;
    }
    
}

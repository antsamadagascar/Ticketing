package controller;

import dao.RegleReservationDAO;
import exception.ValidationError;
import models.RegleReservation;
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

@Controller("RegleReservationController")
@Authentification("manager") 
public class RegleReservationController {
    private RegleReservationDAO regleReservationDao = new RegleReservationDAO();

    @Url("/regles-reservation")
    @Get
    public ModelView getAllReglesReservation() {
        ModelView mv = new ModelView();
        List<RegleReservation> regles = regleReservationDao.getAll();
        
        mv.add("regles", regles);
        mv.setUrl("/WEB-INF/pages/admin/template-admin.jsp");
        mv.add("pageContent", "/WEB-INF/pages/reservation/reservations.jsp");
        
        return mv;
    }

    @Url("/regles-reservation/add")
    @Post
    public ModelView addRegleReservation(
        @Param(name = "heuresAvantVol") String heuresAvantVolStr,
        @Param(name = "active") String activeStr
    ) throws SQLException {
        ModelView mv = new ModelView();
        ValidationError validationError = new ValidationError();

        Integer heuresAvantVol = null;
        Boolean active = null;

        if (heuresAvantVolStr == null || heuresAvantVolStr.trim().isEmpty()) {
            validationError.addError("heuresAvantVol", "Le champ 'Heures avant vol' est obligatoire.");
        } else {
            try {
                heuresAvantVol = Integer.parseInt(heuresAvantVolStr);
                if (heuresAvantVol <= 0) {
                    validationError.addError("heuresAvantVol", "Le nombre d'heures doit être supérieur à 0.");
                }
            } catch (NumberFormatException e) {
                validationError.addError("heuresAvantVol", "Le format du champ 'Heures avant vol' est invalide.");
            }
        }

        if (activeStr == null || activeStr.trim().isEmpty()) {
            validationError.addError("active", "Le champ 'Active' est obligatoire.");
        } else {
            active = Boolean.parseBoolean(activeStr);
        }

        if (validationError.hasErrors()) {
            mv.add("errors", validationError.getFieldErrors());
            mv.add("heuresAvantVol", heuresAvantVolStr);
            mv.add("active", activeStr);
            mv.setUrl("/WEB-INF/pages/admin/template-admin.jsp");
            mv.add("pageContent", "/WEB-INF/pages/reservation/reservations.jsp");
            return mv;
        }

        RegleReservation regle = new RegleReservation();
        regle.setHeuresAvantVol(heuresAvantVol);
        regle.setActive(active);
        
        regleReservationDao.add(regle);

        mv = getAllReglesReservation();
        mv.add("successMessage", "La règle de réservation a été ajoutée avec succès !");
        return mv;
    }

    @Url("/regles-reservation/edit")
    @Get
    public ModelView editRegleReservation(@Param(name = "id") int id) {
        ModelView mv = new ModelView();
        List<RegleReservation> regles = regleReservationDao.getAll();
        
        Optional<RegleReservation> regle = regles.stream().filter(r -> r.getId() == id).findFirst();
        
        if (regle.isPresent()) {
            mv.add("regle", regle.get());
        }
        
        mv.setUrl("/WEB-INF/pages/admin/template-admin.jsp");
        mv.add("pageContent", "/WEB-INF/pages/reservation/edit-reservation.jsp");
        
        return mv;
    }

    @Url("/regles-reservation/update")
    @Post
    public ModelView updateRegleReservation(
        @Param(name = "id") String idStr,
        @Param(name = "heuresAvantVol") String heuresAvantVolStr,
        @Param(name = "active") String activeStr
    ) throws SQLException {
        ModelView mv = new ModelView();
        ValidationError validationError = new ValidationError();

        Integer id = null;
        Integer heuresAvantVol = null;
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

        if (heuresAvantVolStr == null || heuresAvantVolStr.trim().isEmpty()) {
            validationError.addError("heuresAvantVol", "Le champ 'Heures avant vol' est obligatoire.");
        } else {
            try {
                heuresAvantVol = Integer.parseInt(heuresAvantVolStr);
                if (heuresAvantVol <= 0) {
                    validationError.addError("heuresAvantVol", "Le nombre d'heures doit être supérieur à 0.");
                }
            } catch (NumberFormatException e) {
                validationError.addError("heuresAvantVol", "Le format du champ 'Heures avant vol' est invalide.");
            }
        }

        if (activeStr == null || activeStr.trim().isEmpty()) {
            validationError.addError("active", "Le champ 'Active' est obligatoire.");
        } else {
            active = Boolean.parseBoolean(activeStr);
        }

        List<RegleReservation> regles = regleReservationDao.getAll();
        final int finalId = id; // Rendre la variable finale pour utilisation dans la lambda
        Optional<RegleReservation> regle = regles.stream().filter(r -> r.getId() == finalId).findFirst();

        if (regle.isEmpty()) {
            validationError.addError("id", "Règle de réservation introuvable.");
        }

        if (validationError.hasErrors()) {
            mv.add("errors", validationError.getFieldErrors());
            mv.add("id", idStr);
            mv.add("heuresAvantVol", heuresAvantVolStr);
            mv.add("active", activeStr);
            mv.setUrl("/WEB-INF/pages/admin/template-admin.jsp");
            mv.add("pageContent", "/WEB-INF/pages/reservation/edit-reservation.jsp");
            return mv;
        }

        RegleReservation updatedRegle = regle.get();
        updatedRegle.setHeuresAvantVol(heuresAvantVol);
        updatedRegle.setActive(active);
        regleReservationDao.update(updatedRegle);

        mv = getAllReglesReservation();
        mv.add("successMessage", "La règle de réservation a été mise à jour avec succès !");
        return mv;
    }
}

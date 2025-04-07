package controller;

import dao.PromotionVolDAO;
import dao.TypeSiegeDAO;
import dao.VolDao;
import exception.ValidationError;
import models.PromotionVol;
import models.TypeSiege;
import models.Vol;
import other.ModelView;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Optional;

import annotation.Controller;
import annotation.Param;
import annotation.auth.Authentification;
import annotation.methods.Get;
import annotation.methods.Post;
import annotation.methods.Url;

@Controller("PromotionController")
@Authentification("manager") 
public class PromotionController {
    private PromotionVolDAO promotionVolDao = new PromotionVolDAO();
    private VolDao volDao = new VolDao();
    private TypeSiegeDAO typeSiegeDao = new TypeSiegeDAO();

    @Url("/promotions")
    @Get
    public ModelView getAllPromotions() {
        ModelView mv = new ModelView();
        List<PromotionVol> promotions = promotionVolDao.getAll();
        List<Vol> vols = volDao.getAll();
        List<TypeSiege> typesSiege = typeSiegeDao.getAll();
        
        mv.add("promotions", promotions);
        mv.add("vols", vols);
        mv.add("typesSiege", typesSiege);
        mv.setUrl("/WEB-INF/pages/admin/template-admin.jsp");
        mv.add("pageContent", "/WEB-INF/pages/promotion/promotions.jsp");
        
        return mv;
    }
    @Url("/promotions/add")
    @Post
    public ModelView addPromotion(
        @Param(name = "volId") int volId,
        @Param(name = "typeSiegeId") int typeSiegeId,
        @Param(name = "tauxPromotion") String tauxPromotionStr,  
        @Param(name = "dateDebut") String dateDebut,
        @Param(name = "dateFin") String dateFin
    ) throws ParseException {
        ModelView mv = new ModelView();
        ValidationError validationError = new ValidationError();
    
        double tauxPromotion = 0.0;
        if (tauxPromotionStr == null || tauxPromotionStr.trim().isEmpty()) {
            validationError.addError("tauxPromotion", "Le taux de promotion est obligatoire");
        } else {
            try {
                tauxPromotion = Double.parseDouble(tauxPromotionStr);
                if (tauxPromotion < 0 || tauxPromotion > 100) {
                    validationError.addError("tauxPromotion", "Le taux doit être entre 0 et 100%");
                }
            } catch (NumberFormatException e) {
                validationError.addError("tauxPromotion", "Le taux de promotion doit être un nombre valide");
            }
        }
    
        Date dDebut = null, dFin = null;
        SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
    
        if (dateDebut == null || dateDebut.trim().isEmpty()) {
            validationError.addError("dateDebut", "La date de début est obligatoire");
        } else {
            try {
                dDebut = format.parse(dateDebut);
            } catch (ParseException e) {
                validationError.addError("dateDebut", "Format de date de début invalide");
            }
        }
    
        if (dateFin == null || dateFin.trim().isEmpty()) {
            validationError.addError("dateFin", "La date de fin est obligatoire");
        } else {
            try {
                dFin = format.parse(dateFin);
            } catch (ParseException e) {
                validationError.addError("dateFin", "Format de date de fin invalide");
            }
        }
    
        if (dDebut != null && dFin != null && dFin.before(dDebut)) {
            validationError.addError("dateFin", "La date de fin doit être postérieure à la date de début");
        }
    
        List<Vol> vols = volDao.getAll();
        List<TypeSiege> typesSiege = typeSiegeDao.getAll();
        List<PromotionVol> promotions = promotionVolDao.getAll();
    
        if (validationError.hasErrors()) {
            validationError.getFieldErrors().forEach((field, error) -> mv.add(field + "Error", error));
            mv.add("promotions", promotions);
            mv.add("vols", vols);
            mv.add("typesSiege", typesSiege);
            mv.setUrl("/WEB-INF/pages/admin/template-admin.jsp");
            mv.add("pageContent", "/WEB-INF/pages/promotion/promotions.jsp");
            return mv;
        }
    
        Optional<Vol> vol = vols.stream().filter(v -> v.getId() == volId).findFirst();
        Optional<TypeSiege> typeSiege = typesSiege.stream().filter(ts -> ts.getId() == typeSiegeId).findFirst();
    
        if (vol.isPresent() && typeSiege.isPresent()) {
            PromotionVol promotion = new PromotionVol();
            promotion.setVol(vol.get());
            promotion.setTypeSiege(typeSiege.get());
            promotion.setTauxPromotion(tauxPromotion);
            promotion.setDateDebut(new java.sql.Timestamp(dDebut.getTime()));
            promotion.setDateFin(new java.sql.Timestamp(dFin.getTime()));
    
            promotionVolDao.add(promotion);
    
            mv.add("successMessage", "La promotion a été ajoutée avec succès !");
        }
    
        // Recharger la liste des promotions après l'ajout
        promotions = promotionVolDao.getAll();
    
        mv.add("promotions", promotions);
        mv.add("vols", vols);
        mv.add("typesSiege", typesSiege);
        mv.setUrl("/WEB-INF/pages/admin/template-admin.jsp");
        mv.add("pageContent", "/WEB-INF/pages/promotion/promotions.jsp");
    
        return mv;
    }
    
    
    @Url("/promotions/edit")
    @Get
    public ModelView editPromotion(@Param(name = "id") int id) {
        ModelView mv = new ModelView();
        List<PromotionVol> promotions = promotionVolDao.getAll();
        List<Vol> vols = volDao.getAll();
        List<TypeSiege> typesSiege = typeSiegeDao.getAll();
        
        Optional<PromotionVol> promotion = promotions.stream().filter(p -> p.getId() == id).findFirst();
        
        if (promotion.isPresent()) {
            mv.add("promotion", promotion.get());
        }
        
        mv.add("vols", vols);
        mv.add("typesSiege", typesSiege);
        mv.setUrl("/WEB-INF/pages/admin/template-admin.jsp");
        mv.add("pageContent", "/WEB-INF/pages/promotion/edit-promotion.jsp");
        
        return mv;
    }

    @Url("/promotions/update")
    @Post
    public ModelView updatePromotion(
        @Param(name = "id") int id,
        @Param(name = "volId") int volId,
        @Param(name = "typeSiegeId") int typeSiegeId,
        @Param(name = "tauxPromotion") String tauxPromotionStr,
        @Param(name = "dateDebut") String dateDebut,
        @Param(name = "dateFin") String dateFin
    ) throws ParseException {
        ModelView mv = new ModelView();
        ValidationError validationError = new ValidationError();
        SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");

        double tauxPromotion = 0.0;
        if (tauxPromotionStr == null || tauxPromotionStr.trim().isEmpty()) {
            validationError.addError("tauxPromotion", "Le taux de promotion est obligatoire");
        } else {
            try {
                tauxPromotion = Double.parseDouble(tauxPromotionStr);
                if (tauxPromotion < 0 || tauxPromotion > 100) {
                    validationError.addError("tauxPromotion", "Le taux doit être entre 0 et 100%");
                }
            } catch (NumberFormatException e) {
                validationError.addError("tauxPromotion", "Le taux de promotion doit être un nombre valide");
            }
        }

        Date dDebut = null, dFin = null;
        if (dateDebut == null || dateDebut.trim().isEmpty()) {
            validationError.addError("dateDebut", "La date de début est obligatoire");
        } else {
            try {
                dDebut = format.parse(dateDebut);
            } catch (ParseException e) {
                validationError.addError("dateDebut", "Format de date de début invalide");
            }
        }

        if (dateFin == null || dateFin.trim().isEmpty()) {
            validationError.addError("dateFin", "La date de fin est obligatoire");
        } else {
            try {
                dFin = format.parse(dateFin);
            } catch (ParseException e) {
                validationError.addError("dateFin", "Format de date de fin invalide");
            }
        }

        if (dDebut != null && dFin != null && dFin.before(dDebut)) {
            validationError.addError("dateFin", "La date de fin doit être postérieure à la date de début");
        }

        List<PromotionVol> promotions = promotionVolDao.getAll();
        List<Vol> vols = volDao.getAll();
        List<TypeSiege> typesSiege = typeSiegeDao.getAll();

        Optional<PromotionVol> promotion = promotions.stream().filter(p -> p.getId() == id).findFirst();
        Optional<Vol> vol = vols.stream().filter(v -> v.getId() == volId).findFirst();
        Optional<TypeSiege> typeSiege = typesSiege.stream().filter(ts -> ts.getId() == typeSiegeId).findFirst();

        if (validationError.hasErrors()) {
            validationError.getFieldErrors().forEach((field, error) -> mv.add(field + "Error", error));
            mv.add("promotions", promotions);
            mv.add("vols", vols);
            mv.add("typesSiege", typesSiege);
            mv.setUrl("/WEB-INF/pages/admin/template-admin.jsp");
            mv.add("pageContent", "/WEB-INF/pages/promotion/promotions.jsp");
            return mv;
        }

        if (promotion.isPresent() && vol.isPresent() && typeSiege.isPresent()) {
            PromotionVol updatedPromotion = promotion.get();
            updatedPromotion.setVol(vol.get());
            updatedPromotion.setTypeSiege(typeSiege.get());
            updatedPromotion.setTauxPromotion(tauxPromotion);
            updatedPromotion.setDateDebut(new java.sql.Timestamp(dDebut.getTime()));
            updatedPromotion.setDateFin(new java.sql.Timestamp(dFin.getTime()));

            promotionVolDao.update(updatedPromotion);
            mv.add("successMessage", "La promotion a été mise à jour avec succès !");
        }

        mv.add("promotions", promotions);
        mv.add("vols", vols);
        mv.add("typesSiege", typesSiege);
        mv.setUrl("/WEB-INF/pages/admin/template-admin.jsp");
        mv.add("pageContent", "/WEB-INF/pages/promotion/promotions.jsp");

        return mv;
    }

}

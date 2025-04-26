package controller;

import dao.TypeSiegeDAO;
import dao.VilleDao;
import dao.VolMulticritereDAO;
import models.TypeSiege;
import models.Ville;
import models.VolMulticritereResult;
import mg.itu.nyantsa.other.ModelView;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import mg.itu.nyantsa.annotation.Controller;
import mg.itu.nyantsa.annotation.Param;
import mg.itu.nyantsa.annotation.auth.Authentification;
import mg.itu.nyantsa.annotation.methods.Get;
import mg.itu.nyantsa.annotation.methods.Post;
import mg.itu.nyantsa.annotation.methods.Url;


@Controller("RechercheController")
@Authentification  
public class RechercheController {

    private final VolMulticritereDAO volDao = new VolMulticritereDAO();
    private final VilleDao villeDao = new VilleDao();
    private final TypeSiegeDAO typeSiegeDao = new TypeSiegeDAO();

    @Url("/recherche")
    @Get
    public ModelView afficherFormulaireRecherche() {
        ModelView mv = new ModelView();
        List<Ville> villes = villeDao.getAll();
        List<TypeSiege> typesSiege = typeSiegeDao.getAll();
        
        mv.add("villes", villes);
        mv.add("typesSiege", typesSiege);
        
        mv.setUrl("/WEB-INF/pages/user/template-user.jsp");
        mv.add("pageContent", "/WEB-INF/pages/recherche/recherche-combined.jsp"); 
        return mv;
    }

   @Url("/recherche/resultats")
    @Post
    public ModelView rechercherVols(
        @Param(name = "villeDepartId") int villeDepartId,
        @Param(name = "villeArriveeId") int villeArriveeId,
        @Param(name = "dateDepart") String dateDepart,
        @Param(name = "typeSiegeId") int typeSiegeId,
        @Param(name = "prixMin") String prixMinStr, 
        @Param(name = "prixMax") String prixMaxStr,
        @Param(name = "nombrePassagers") int nombrePassagers
    ) {
        ModelView mv = new ModelView();
        
        Ville villeDepart = new Ville();
        villeDepart.setId(villeDepartId);
        
        Ville villeArrivee = new Ville();
        villeArrivee.setId(villeArriveeId);
        
        TypeSiege typeSiege = new TypeSiege();
        typeSiege.setId(typeSiegeId);
        
        LocalDateTime dateDepartParsed = LocalDateTime.parse(dateDepart);

        BigDecimal prixMin = (prixMinStr != null && !prixMinStr.isEmpty()) 
            ? new BigDecimal(prixMinStr) 
            : null;
        BigDecimal prixMax = (prixMaxStr != null && !prixMaxStr.isEmpty()) 
            ? new BigDecimal(prixMaxStr) 
            : null;

        List<VolMulticritereResult> vols = volDao.rechercherVols(
            villeDepart, villeArrivee, dateDepartParsed, typeSiege, prixMin, prixMax, nombrePassagers
        );

        List<Ville> villes = villeDao.getAll();
        List<TypeSiege> typesSiege = typeSiegeDao.getAll();
        
        mv.add("villes", villes);
        mv.add("typesSiege", typesSiege);
        mv.add("vols", vols);
        
        mv.setUrl("/WEB-INF/pages/user/template-user.jsp");
        mv.add("pageContent", "/WEB-INF/pages/recherche/recherche-combined.jsp"); 
        return mv;
        } 
}

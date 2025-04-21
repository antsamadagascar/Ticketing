package controller;

import dao.UserDAO;
import models.Utilisateur;
import java.util.List;
import annotation.Controller;
import annotation.Param;
import annotation.methods.Get;
import annotation.methods.Post;
import annotation.methods.Url;
import other.ModelView;
import other.MySession;
import exception.ValidationException;
import annotation.ValidateForm;
import annotation.auth.Authentification;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

@Controller("AuthController")
public class AuthController {
    private static final UserDAO userDAO = new UserDAO();
    private static final ValidateForm validator = new ValidateForm();
   
    @Url("/login-page")
    @Get
    public ModelView loginPage() {
        ModelView mv = new ModelView();
        mv.setUrl("WEB-INF/pages/login/login.jsp");
        return mv;
    }

    @Url("/auth/login")
    @Post
    public ModelView login(@Param(name = "email") String email,
                        @Param(name = "password") String password,
                        MySession session) {
        ModelView mv = new ModelView();
        
        try {
            Utilisateur tempUser = new Utilisateur();
            tempUser.setEmail(email);
            tempUser.setMotDePasse(password);
        
            validator.validateObject(tempUser);
            
            List<Utilisateur> utilisateurs = userDAO.getAll();
            BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();

            Utilisateur user = utilisateurs.stream()
                .filter(u -> u.getEmail().equals(email) && encoder.matches(password, u.getMotDePasse()))
                .findFirst()
                .orElse(null);
            
            if (user != null) {
                session.add("authUser", user);
                session.add("rolesUser", user.getRole());
                
                if ("manager".equals(user.getRole())) {
                    mv.setUrl("/WEB-INF/pages/admin/template-admin.jsp");
                    mv.add("pageContent", "/WEB-INF/pages/admin/home.jsp");
                } else {
                    mv.setUrl("/WEB-INF/pages/user/template-user.jsp");
                    mv.add("pageContent", "/WEB-INF/pages/user/home.jsp");
                }
            } else {
                mv.setUrl("WEB-INF/pages/login/login.jsp");
                mv.add("error", "Email ou mot de passe incorrect ");
            }
            
        } catch (ValidationException ve) {
            mv.setUrl("WEB-INF/pages/login/login.jsp");
            ve.getValidationErrors().forEach((field, error) -> {
                mv.add(field + "Error", error); 
            });
            mv.add("email", email);
        }
        
        return mv;
    }

    @Url("/logout")
    @Get
    public ModelView logout(MySession session) {
        session.delete("authUser");
        session.delete("rolesUser");
        ModelView mv = new ModelView();
        mv.setUrl("WEB-INF/pages/login/login.jsp");
        return mv;
    }
}
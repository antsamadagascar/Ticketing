package controller;

import mg.itu.nyantsa.annotation.Controller;
import mg.itu.nyantsa.annotation.auth.Authentification;
import mg.itu.nyantsa.annotation.methods.Url;
import mg.itu.nyantsa.other.ModelView;

@Controller("AdminController")
@Authentification("manager") 
public class AdminController {
    
    @Url("/admin/dashboard")

    public ModelView adminDashboard() {
        ModelView mv = new ModelView();
        mv.setUrl("admin/dashboard2.jsp");
        return mv;
    }
    
    @Url("/profile")
    @Authentification  
    public ModelView userProfile() {
        ModelView mv = new ModelView();
        mv.setUrl("user/profile.jsp");
        return mv;
    }
    
    @Url("/public/news")
    @Authentification("public")  // Surcharge pour autoriser tous les rôles
    public ModelView publicNews() {
        ModelView mv = new ModelView();
        mv.setUrl("user/news.jsp");
        return mv;
    }
}
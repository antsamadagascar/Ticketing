package controller;

import mg.itu.nyantsa.annotation.Controller;
import mg.itu.nyantsa.annotation.methods.Get;
import mg.itu.nyantsa.annotation.methods.Url;
import mg.itu.nyantsa.other.ModelView;

@Controller("HomeController")
public class HomeController {

    @Url("/home")
    @Get
    public ModelView homePage() {
        ModelView mv = new ModelView();
        mv.setUrl("/WEB-INF/views/template.jsp"); 
        mv.add("pageContent", "/WEB-INF/views/home.jsp");
        return mv;
    }
}

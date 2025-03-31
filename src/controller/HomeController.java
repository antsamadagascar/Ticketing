package controller;

import annotation.Controller;
import annotation.methods.Get;
import annotation.methods.Url;
import other.ModelView;

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

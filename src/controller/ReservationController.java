package controller;

import annotation.Controller;
import annotation.Param;
import annotation.auth.Authentification;
import annotation.methods.Get;
import annotation.methods.Post;
import annotation.methods.RestApi;
import annotation.methods.Url;
import dao.ReservationDao;
import dao.SiegeVolDAO;
import dao.VolDao;
import models.Reservation;
import models.SiegeVol;
import models.Utilisateur;
import models.Vol;
import other.FileUpload;
import other.ModelView;
import other.MySession;
import utils.connection.PostgresConnection;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.sql.SQLException;
import java.util.List;

@Controller("ReservationController")
@Authentification
public class ReservationController {
    private VolDao volDao = new VolDao();
    private SiegeVolDAO siegeVolDAO = new SiegeVolDAO(PostgresConnection.getConnection());
    private static final ReservationDao reservationDao = new ReservationDao();

    private List<Vol> vols = volDao.getAll();

    @Url("/reservation-vol")
    @Get
    public ModelView reservationVols() {
        ModelView mv = new ModelView();
        
        mv.add("vols", vols); 
        mv.setUrl("/WEB-INF/pages/user/template-user.jsp");
        mv.add("pageContent", "/WEB-INF/pages/reservation/reservation-vol.jsp");

        return mv;
    }

    @Url("/sieges-disponibles")
    @RestApi
    @Get
    public List<SiegeVol> getSiegesDisponibles(@Param(name = "volId") int volId) {
        return siegeVolDAO.getSiegesDisponiblesParVol(volId);
    }

    @Url("/mes-reservation")
    @Get
    public ModelView getReservationUtilisateur(MySession session) {
        ModelView mv = new ModelView();
        
        Object authUser = session.get("authUser");
        if (authUser instanceof Utilisateur) {
            Utilisateur utilisateur = (Utilisateur) authUser;
            List<Reservation> reservations = reservationDao.getByIdUser(utilisateur.getId());
            mv.add("reservations", reservations);
        }
        
        mv.setUrl("/WEB-INF/pages/user/template-user.jsp");
        mv.add("pageContent", "/WEB-INF/pages/reservation/mes-reservation.jsp");
        return mv;
    }

    @Url("/reservation/annuler")
    @Post
    public ModelView annulerReservation(@Param(name = "reservationId") int reservationId, MySession session) {
        ModelView mv = new ModelView();
    
        if (reservationId <= 0) {
            mv.add("messageError", "ID de réservation invalide.");
            mv.setUrl("/WEB-INF/pages/user/template-user.jsp");
            mv.add("pageContent", "/WEB-INF/pages/reservation/mes-reservation.jsp");
            return mv;
        }
    
        Object authUser = session.get("authUser");
        if (authUser instanceof Utilisateur) {
            Utilisateur utilisateur = (Utilisateur) authUser;
            
            try {
                boolean success = reservationDao.annulerReservation(reservationId, utilisateur.getId());
                if (success) {
                    mv.add("messageSuccess", "La réservation a été annulée avec succès.");
                } else {
                    mv.add("messageError", "L'annulation de la réservation a échoué ou n'est plus possible.");
                }
            } catch (SQLException e) {
                String erreurMessage = e.getMessage();
                System.out.println("SQLException message: " + erreurMessage); // Log
                if (erreurMessage.toLowerCase().contains("annulation doit")) {
                    try {
                        int heuresAnnulation = reservationDao.getHeuresAnnulation();
                        String message = String.format("L'annulation doit être faite dans les %d heure%s suivant la réservation.",
                                heuresAnnulation, heuresAnnulation > 1 ? "s" : "");
                        mv.add("messageError", message);
                    } catch (SQLException ex) {
                        mv.add("messageError", "Erreur lors de la vérification du délai d'annulation.");
                    }
                } else {
                    mv.add("messageError", "Une erreur de base de données s'est produite lors de l'annulation.");
                }
            } catch (Exception e) {
                mv.add("messageError", "Une erreur inattendue s'est produite : " + e.getMessage());
            }
    
            try {
                List<Reservation> reservations = reservationDao.getByIdUser(utilisateur.getId());
                mv.add("reservations", reservations);
            } catch (Exception e) {
                mv.add("messageError", "Erreur lors du chargement des réservations : " + e.getMessage());
            }
        } else {
            mv.add("messageError", "Vous devez être connecté pour annuler une réservation.");
        }
    
        mv.setUrl("/WEB-INF/pages/user/template-user.jsp");
        mv.add("pageContent", "/WEB-INF/pages/reservation/mes-reservation.jsp");
        return mv;
    }

    public String saveFile(FileUpload fileUpload, int userId, int volId, int reservationId) throws IOException {
        String userFolder = "C:\\Program Files\\Apache Software Foundation\\Tomcat 10.1\\webapps\\Ticketing\\upload\\utilisateur_" + userId;
        Files.createDirectories(Paths.get(userFolder));
        String volFolder = userFolder + "\\vol_" + volId;
        Files.createDirectories(Paths.get(volFolder));

        String reservationFolder = volFolder + "\\reservation_" + reservationId;
        Files.createDirectories(Paths.get(reservationFolder));

        String filePath = reservationFolder + "\\";
        fileUpload.setFilePath(filePath);
        fileUpload.saveFile();

        return filePath;
    }

    @Url("/reservation/valider")
    @Post
    public ModelView validerReservation(@Param(name = "volId") int volId,
                                        @Param(name = "siegeId") int siegeId,
                                        @Param(name = "nombrePassagers") int nombrePassagers,
                                        @Param(name = "passeport") FileUpload passeport,
                                        MySession session) {
        ModelView mv = new ModelView();
        ReservationDao reservationDao = new ReservationDao();
        
        System.out.println("=== Début traitement validerReservation ===");
        System.out.println("Vol ID: " + volId);
        System.out.println("Siège ID: " + siegeId);
        System.out.println("Nombre de passagers: " + nombrePassagers);
        
        if (passeport == null) {
            System.out.println("ERREUR: Aucun fichier passeport reçu!");
            mv.add("messageError", "Veuillez fournir un fichier passeport.");
            mv.setUrl("/WEB-INF/pages/user/template-user.jsp");
            mv.add("pageContent", "/WEB-INF/pages/reservation/mes-reservation.jsp");
            return mv;
        }
        
        Object authUser = session.get("authUser");
        if (authUser instanceof Utilisateur utilisateur) {
            try {
                int reservationId = reservationDao.creerReservation(
                    utilisateur.getId(), volId, siegeId, nombrePassagers, passeport.getFileName());
                String filePath = saveFile(passeport, utilisateur.getId(), volId, reservationId);
                mv.add("messageSuccess", "Réservation effectuée avec succès !");
            } catch (SQLException e) {
                System.out.println("ERREUR SQL: " + e.getMessage());
                if (e.getMessage().toLowerCase().contains("réservation doit être faite")) {
                    try {
                        int heuresReservation = reservationDao.getHeuresReservation();
                        String message = String.format(
                            "La réservation doit être faite au moins %d heure%s avant le vol.",
                            heuresReservation, heuresReservation > 1 ? "s" : "");
                        mv.add("messageError", message);
                    } catch (SQLException ex) {
                        mv.add("messageError", "Erreur lors de la vérification du délai de réservation.");
                    }
                } else {
                    mv.add("messageError", "Erreur lors de la création de la réservation.");
                }
            } catch (IOException e) {
                System.out.println("ERREUR IO: " + e.getMessage());
                mv.add("messageError", "Erreur lors de la sauvegarde du fichier.");
            } catch (Exception e) {
                System.out.println("ERREUR GÉNÉRALE: " + e.getMessage());
                mv.add("messageError", "Erreur inattendue.");
            }

            try {
                List<Reservation> reservations = reservationDao.getByIdUser(utilisateur.getId());
                mv.add("reservations", reservations);
            } catch (Exception e) {
                mv.add("messageError", "Erreur lors du chargement des réservations.");
            }
        } else {
            mv.add("messageError", "Veuillez vous connecter pour effectuer une réservation.");
        }

 
        mv.add("vols", vols); 
        mv.setUrl("/WEB-INF/pages/user/template-user.jsp");
        mv.add("pageContent", "/WEB-INF/pages/reservation/reservation-vol.jsp");
        System.out.println("=== Fin traitement validerReservation ===");
        return mv;
    }

    @Url("/reservation/passeport")
    @Get
    public ModelView afficherPasseport(@Param(name = "reservationId") int reservationId) {
        ModelView mv = new ModelView();

        try {
            String filePath = reservationDao.getPasseportFilePath(reservationId);

            if (filePath != null) {
                Path path = Paths.get(filePath);
                byte[] fileData = Files.readAllBytes(path);

                mv.add("fileData", fileData);
                mv.add("fileName", path.getFileName().toString());
                mv.setUrl("/WEB-INF/pages/reservation/afficher-passeport.jsp");
            } else {
                mv.add("error", "Fichier non trouvé");
                mv.setUrl("/WEB-INF/pages/error.jsp");
            }
        } catch (SQLException | IOException e) {
            mv.add("error", "Erreur lors de la récupération du fichier : " + e.getMessage());
            mv.setUrl("/WEB-INF/pages/error.jsp");
        }

        return mv;
    }
}

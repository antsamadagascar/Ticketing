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
import models.Passager;
import models.Reservation;
import models.SiegeVol;
import models.Utilisateur;
import models.Vol;
import other.FileUpload;
import other.ModelView;
import other.MySession;
import utils.connection.PostgresConnection;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.sql.Date;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;


import com.fasterxml.jackson.databind.ObjectMapper;

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
        mv.add("pageContent", "/WEB-INF/pages/reservation/add-reservation-vol.jsp");

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
                System.out.println("SQLException message: " + erreurMessage); 
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

    public String saveFile(FileUpload fileUpload, int userId, int volId, int reservationId, int passagerId) throws IOException {
        String userFolder = "C:\\Program Files\\Apache Software Foundation\\Tomcat 10.1\\webapps\\data_reservation_ticketing\\utilisateur_" + userId;
        Files.createDirectories(Paths.get(userFolder));
        String volFolder = userFolder + "\\vol_" + volId;
        Files.createDirectories(Paths.get(volFolder));
    
        String reservationFolder = volFolder + "\\reservation_" + reservationId;
        Files.createDirectories(Paths.get(reservationFolder));

        String passagerFolder = reservationFolder + "\\passager_" + passagerId;
        Files.createDirectories(Paths.get(passagerFolder));
    
        String filePath = passagerFolder + "\\";
        fileUpload.setFilePath(filePath);
        fileUpload.saveFile();
    
        return filePath;
    }
    
    @Url("/reservation/valider")
    @Post
    public ModelView validerReservation(
            @Param(name = "volId") int volId,
            @Param(name = "dateReservation") String  dateReservationStr,
            @Param(name = "siegeId") List<Integer> siegeId,
            @Param(name = "nombrePassagers") int nombrePassagers,
            @Param(name = "passeport") List<FileUpload> passeports,
            @Param(name = "passagers") String passagersJson,
            MySession session
    ) {
        ModelView mv = new ModelView();
        ReservationDao reservationDao = new ReservationDao();
    
        System.out.println("Début de la méthode validerReservation");
    
        if (passeports == null || passeports.isEmpty() || passeports.size() != nombrePassagers) {
            mv.add("messageError", "Veuillez fournir un fichier passeport pour chaque passager.");
            mv.setUrl("/WEB-INF/pages/user/template-user.jsp");
            mv.add("pageContent", "/WEB-INF/pages/reservation/add-reservation-vol.jsp");
            return mv;
        }
    
        if (siegeId == null || siegeId.size() != nombrePassagers) {
            mv.add("messageError", "Le nombre de sièges sélectionnés ne correspond pas.");
            mv.setUrl("/WEB-INF/pages/user/template-user.jsp");
            mv.add("pageContent", "/WEB-INF/pages/reservation/add-reservation-vol.jsp");
            return mv;
        }
    
        ObjectMapper objectMapper = new ObjectMapper();
        objectMapper.setDateFormat(new SimpleDateFormat("yyyy-MM-dd"));
        List<Passager> listePassagers = new ArrayList<>();

        try {
            System.out.println("Contenu du JSON des passagers: " + passagersJson);
    
            List<Passager> passagers = objectMapper.readValue(passagersJson, objectMapper.getTypeFactory().constructCollectionType(List.class, Passager.class));
    
            if (passagers == null || passagers.size() != nombrePassagers) {
                mv.add("messageError", "Le nombre de passagers ne correspond pas.");
                mv.setUrl("/WEB-INF/pages/user/template-user.jsp");
                mv.add("pageContent", "/WEB-INF/pages/reservation/add-reservation-vol.jsp");
                return mv;
            }
    
            for (int i = 0; i < passagers.size(); i++) {
                Passager p = passagers.get(i);
                if (p.getNom() == null || p.getNom().isEmpty() ||
                    p.getPrenom() == null || p.getPrenom().isEmpty() ||
                    p.getDateNaissance() == null) {
                    mv.add("messageError", "Données incomplètes pour le passager " + (i + 1));
                    mv.setUrl("/WEB-INF/pages/user/template-user.jsp");
                    mv.add("pageContent", "/WEB-INF/pages/reservation/add-reservation-vol.jsp");
                    return mv;
                }
    
                String fileName = passeports.get(i).getFileName();
                Passager complet = new Passager(0, 0, p.getNom(), p.getPrenom(), p.getDateNaissance(), fileName);
                listePassagers.add(complet);
            }
        } catch (Exception e) {
            System.out.println("Erreur lors du parsing des passagers: " + e.getMessage());
            mv.add("messageError", "Erreur lors du parsing des données des passagers: " + e.getMessage());
            mv.setUrl("/WEB-INF/pages/user/template-user.jsp");
            mv.add("pageContent", "/WEB-INF/pages/reservation/mes-reservation.jsp");
            return mv;
        }
    
        Object authUser = session.get("authUser");
        if (authUser instanceof Utilisateur utilisateur) {
            try {
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
                java.util.Date utilDate = null;

                try {
                    utilDate = sdf.parse(dateReservationStr);
                    if (utilDate == null) {
                        throw new IllegalArgumentException("Date invalide");
                    }
                } catch (ParseException e) {
                    e.printStackTrace();
                    throw new IllegalArgumentException("Format de date invalide : " + dateReservationStr);
                }

                Timestamp dateReservation = new java.sql.Timestamp(utilDate.getTime());

                int reservationId = reservationDao.creerReservation(utilisateur.getId(), volId,dateReservation, listePassagers, siegeId);
                System.out.println("id reservation:" + reservationId);
                
                for (int i = 0; i < listePassagers.size(); i++) {
                    Passager passager = listePassagers.get(i);
                    FileUpload passeport = passeports.get(i);
                    
                    int passagerId = passager.getId() > 0 ? passager.getId() : i + 1;
                    
                    saveFile(passeport, utilisateur.getId(), volId, reservationId, passagerId);
                }  
                mv.add("messageSuccess", "Réservation effectuée avec succès !");
            } catch (SQLException e) {
                if (e.getMessage().toLowerCase().contains("réservation doit être faite")) {
                    try {
                        int heuresReservation = reservationDao.getHeuresReservation();
                        String message = "La réservation doit être faite au moins " + heuresReservation + " heure" + (heuresReservation > 1 ? "s" : "") + " avant le vol.";
                        mv.add("messageError", message);
                    } catch (SQLException ex) {
                        mv.add("messageError", "Erreur lors de la vérification du délai de réservation.");
                    }
                } else {
                    mv.add("messageError", "Erreur lors de la réservation.");
                }
            } catch (IOException e) {
                mv.add("messageError", "Erreur lors de l'enregistrement des fichiers passeport: " + e.getMessage());
            }
        } else {
            mv.add("messageError", "Utilisateur non authentifié.");
        }
    
        mv.setUrl("/WEB-INF/pages/user/template-user.jsp");
        mv.add("pageContent", "/WEB-INF/pages/reservation/add-reservation-vol.jsp");
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

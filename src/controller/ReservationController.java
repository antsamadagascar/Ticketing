package controller;

import mg.itu.nyantsa.annotation.Controller;
import mg.itu.nyantsa.annotation.Param;
import mg.itu.nyantsa.annotation.auth.Authentification;
import mg.itu.nyantsa.annotation.methods.Get;
import mg.itu.nyantsa.annotation.methods.Post;
import mg.itu.nyantsa.annotation.methods.RestApi;
import mg.itu.nyantsa.annotation.methods.Url;
import dao.ReservationDao;
import dao.SiegeVolDAO;
import dao.VolDao;
import models.Passager;
import models.Reservation;
import models.SiegeVol;
import models.Utilisateur;
import models.Vol;
import mg.itu.nyantsa.other.FileUpload;
import mg.itu.nyantsa.other.ModelView;
import mg.itu.nyantsa.other.MySession;
import utils.connection.PostgresConnection;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
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

                // Récupération des passagers avec leurs IDs après création
                List<Passager> passagersAvecIds = reservationDao.creerReservation(utilisateur.getId(), volId, dateReservation, listePassagers, siegeId);
                
                System.out.println("id reservation créée");
                
                // Utilisation des passagers avec les vrais IDs
                for (int i = 0; i < passagersAvecIds.size(); i++) {
                    Passager passager = passagersAvecIds.get(i);
                    System.out.println("Passager avec ID réel : " + passager);
                    FileUpload passeport = passeports.get(i);
                    
                    // Utilisation de l'ID réel du passager
                    int passagerId = passager.getId();
                    
                    saveFile(passeport, utilisateur.getId(), volId, passager.getReservationId(), passagerId);
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
    
    @Url("/reservation/passagers")
    @Get
    public ModelView afficherPassagers(
            @Param(name = "reservationId") int reservationId,
            @Param(name = "volId") int volId,
            MySession session) {
        
        ModelView mv = new ModelView();
        
        // Vérifie l'authentification
        Object authUser = session.get("authUser");
        if (!(authUser instanceof Utilisateur)) {
            mv.add("messageError", "Vous devez être connecté pour voir les détails.");
            mv.setUrl("/WEB-INF/pages/user/template-user.jsp");
            mv.add("pageContent", "/WEB-INF/pages/reservation/mes-reservation.jsp");
            return mv;
        }
        
        Utilisateur utilisateur = (Utilisateur) authUser;
        
        try {
            // Récupére les informations de la réservation
            List<Reservation> reservations = reservationDao.getByIdUser(utilisateur.getId());
            Reservation reservation = null;
            
            for (Reservation r : reservations) {
                if (r.getId() == reservationId) {
                    reservation = r;
                    break;
                }
            }
            
            if (reservation == null) {
                mv.add("messageError", "Réservation non trouvée ou accès non autorisé.");
                mv.setUrl("/WEB-INF/pages/user/template-user.jsp");
                mv.add("pageContent", "/WEB-INF/pages/reservation/mes-reservation.jsp");
                return mv;
            }
            
            // Récupére les informations du vol
            Vol vol = volDao.findById(volId);
            
            // Récupére la liste des passagers
            List<Passager> passagers = reservationDao.getPassagersParReservation(reservationId);
            
            mv.add("reservation", reservation);
            mv.add("vol", vol);
            mv.add("passagers", passagers);
            mv.setUrl("/WEB-INF/pages/user/template-user.jsp");
            mv.add("pageContent", "/WEB-INF/pages/reservation/details-passagers.jsp");
            
        } catch (SQLException e) {
            e.printStackTrace();
            mv.add("messageError", "Erreur lors de la récupération des données: " + e.getMessage());
            mv.setUrl("/WEB-INF/pages/user/template-user.jsp");
            mv.add("pageContent", "/WEB-INF/pages/reservation/mes-reservation.jsp");
        }
        
        return mv;
    }

    
    @Url("/reservation/passeport/afficher")
    @Get
    public ModelView afficherPasseportPassager(
            @Param(name = "reservationId") int reservationId,
            @Param(name = "passagerId") int passagerId,
            MySession session) {
        
        ModelView mv = new ModelView();
        
        try {
            // Vérifier l'authentification
            Object authUser = session.get("authUser");
            if (!(authUser instanceof Utilisateur)) {
                System.out.println("ERROR: Utilisateur non authentifié");
                mv.add("messageError", "Accès non autorisé.");
                mv.setUrl("/WEB-INF/pages/error/error.jsp");
                return mv;
            }
            
            Utilisateur utilisateur = (Utilisateur) authUser;
            System.out.println("Utilisateur connecté: " + utilisateur.getId());
            
            // Vérifi que la réservation appartient à l'utilisateur
            List<Reservation> reservations = reservationDao.getByIdUser(utilisateur.getId());
            boolean reservationValide = false;
            Reservation reservationTrouvee = null;
            
            if (reservations != null) {
                for (Reservation r : reservations) {
                    if (r.getId() == reservationId) {
                        reservationValide = true;
                        reservationTrouvee = r;
                        break;
                    }
                }
            }
            
            if (!reservationValide) {
                System.out.println("ERROR: Accès non autorisé à la réservation: " + reservationId);
                mv.add("messageError", "Accès non autorisé à cette réservation.");
                mv.setUrl("/WEB-INF/pages/error/error.jsp");
                return mv;
            }
            
            // Récupération des informations du passager
            List<Passager> passagers = reservationDao.getPassagersParReservation(reservationId);
            Passager passager = null;
            
            if (passagers != null) {
                for (Passager p : passagers) {
                    if (p.getId() == passagerId) {
                        passager = p;
                        break;
                    }
                }
            }
            
            if (passager == null) {
                System.out.println("ERROR: Passager non trouvé: " + passagerId);
                mv.add("messageError", "Passager non trouvé.");
                mv.setUrl("/WEB-INF/pages/error/error.jsp");
                return mv;
            }
            
            if (passager.getPasseportFileName() == null || passager.getPasseportFileName().isEmpty()) {
                System.out.println("ERROR: Nom de fichier passeport vide pour le passager: " + passagerId);
                mv.add("messageError", "Passeport non disponible pour ce passager.");
                mv.setUrl("/WEB-INF/pages/error/error.jsp");
                return mv;
            }
            
            // Construire le chemin du fichier
            Vol vol = reservationTrouvee.getVol();
            String basePath = "C:\\Program Files\\Apache Software Foundation\\Tomcat 10.1\\webapps\\data_reservation_ticketing\\";
            String filePath = basePath + "utilisateur_" + utilisateur.getId() + 
                            "\\vol_" + vol.getId() + 
                            "\\reservation_" + reservationId + 
                            "\\passager_" + passagerId + 
                            "\\" + passager.getPasseportFileName();
            
            System.out.println("Chemin du fichier: " + filePath);
            
            Path path = Paths.get(filePath);
            
            if (!Files.exists(path)) {
                System.out.println("ERROR: Fichier non trouvé: " + filePath);
                mv.add("messageError", "Fichier passeport non trouvé sur le serveur.");
                mv.setUrl("/WEB-INF/pages/error/error.jsp");
                return mv;
            }
            
            byte[] fileData = Files.readAllBytes(path);
            String fileName = passager.getPasseportFileName();
            
            // Déterminer le type MIME
            String contentType = "application/octet-stream";
            String fileExtension = fileName.substring(fileName.lastIndexOf(".") + 1).toLowerCase();
            
            switch (fileExtension) {
                case "pdf":
                    contentType = "application/pdf";
                    break;
                case "jpg":
                case "jpeg":
                    contentType = "image/jpeg";
                    break;
                case "png":
                    contentType = "image/png";
                    break;
                case "gif":
                    contentType = "image/gif";
                    break;
            }
            
            System.out.println("Fichier lu avec succès. Taille: " + fileData.length + " bytes");
            
            mv.add("fileData", fileData);
            mv.add("fileName", fileName);
            mv.add("contentType", contentType);
            mv.add("passager", passager);
            mv.setUrl("/WEB-INF/pages/user/template-user.jsp");
            mv.add("pageContent", "/WEB-INF/pages/reservation/afficher-passeport.jsp");
            
        } catch (Exception e) {
            System.out.println("ERROR: Exception dans afficherPasseportPassager: " + e.getMessage());
            e.printStackTrace();
            mv.add("messageError", "Erreur lors de la récupération du fichier: " + e.getMessage());
            mv.setUrl("/WEB-INF/pages/error/error.jsp");
        }
        
        return mv;
    }
}

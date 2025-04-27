<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="models.Passager" %>
<%@ page import="models.Reservation" %>
<%@ page import="models.Vol" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Détails des Passagers</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/reservation/details-reservation.css" >
</head>
<body>
    <a href="/Ticketing/mes-reservation" class="back-btn">
        <i class="fas fa-arrow-left"></i> Retour aux réservations
    </a>

    <div class="container">
        <div class="header">
            <h1><i class="fas fa-users"></i> Détails des Passagers</h1>
        </div>

        <%
            String messageError = (String) request.getAttribute("messageError");
            if (messageError != null) {
        %>
            <div class="alert error">
                <i class="fas fa-exclamation-circle"></i> <%= messageError %>
            </div>
        <% } %>

        <%
            Reservation reservation = (Reservation) request.getAttribute("reservation");
            Vol vol = (Vol) request.getAttribute("vol");
            List<Passager> passagers = (List<Passager>) request.getAttribute("passagers");
            
            if (reservation != null && vol != null) {
        %>
        
        <div class="reservation-info">
            <h2><i class="fas fa-info-circle"></i> Informations de la Réservation</h2>
            <div class="info-grid">
                <div class="info-item">
                    <i class="fas fa-hashtag"></i>
                    <div>
                        <strong>ID Réservation:</strong> <%= reservation.getId() %>
                    </div>
                </div>
                <div class="info-item">
                    <i class="fas fa-plane"></i>
                    <div>
                        <strong>Vol:</strong> <%= vol.getNumeroVol() %>
                    </div>
                </div>
                <div class="info-item">
                    <i class="fas fa-calendar"></i>
                    <div>
                        <strong>Date de réservation:</strong> <%= reservation.getDateReservation() %>
                    </div>
                </div>
                <div class="info-item">
                    <i class="fas fa-euro-sign"></i>
                    <div>
                        <strong>Montant total:</strong> <%= reservation.getMontantTotal() %> €
                    </div>
                </div>
                <div class="info-item">
                    <i class="fas fa-plane-departure"></i>
                    <div>
                        <strong>Départ:</strong> <%= vol.getDateDepart() %>
                    </div>
                </div>
                <div class="info-item">
                    <i class="fas fa-plane-arrival"></i>
                    <div>
                        <strong>Arrivée:</strong> <%= vol.getDateArrivee() %>
                    </div>
                </div>
            </div>
        </div>

        <% } %>

        <div class="passengers-section">
            <h2 style="text-align: center; color: #333; margin-bottom: 30px;">
                <i class="fas fa-users"></i> Liste des Passagers
            </h2>

            <% if (passagers != null && !passagers.isEmpty()) { %>
                <div class="passengers-grid">
                    <%
                        for (int i = 0; i < passagers.size(); i++) {
                            Passager passager = passagers.get(i);
                    %>
                    <div class="passenger-card">
                        <div class="passenger-header">
                            <h3><i class="fas fa-user"></i> Passager <%= (i + 1) %></h3>
                        </div>
                        <div class="passenger-details">
                            <div class="detail-row">
                                <span class="detail-label">
                                    <i class="fas fa-user"></i> Nom:
                                </span>
                                <span class="detail-value"><%= passager.getNom() %></span>
                            </div>
                            <div class="detail-row">
                                <span class="detail-label">
                                    <i class="fas fa-user"></i> Prénom:
                                </span>
                                <span class="detail-value"><%= passager.getPrenom() %></span>
                            </div>
                            <div class="detail-row">
                                <span class="detail-label">
                                    <i class="fas fa-birthday-cake"></i> Date de naissance:
                                </span>
                                <span class="detail-value"><%= passager.getDateNaissance() %></span>
                            </div>
                        </div>
                        <div class="passport-section">
                            <% if (passager.getPasseportFileName() != null && !passager.getPasseportFileName().isEmpty()) { %>
                                <a href="/Ticketing/reservation/passeport/afficher?reservationId=<%= reservation != null ? reservation.getId() : 0 %>&passagerId=<%= passager.getId() %>" 
                                   class="passport-btn" target="_blank">
                                    <i class="fas fa-passport"></i> Voir le passeport
                                </a>
                            <% } else { %>
                                <span class="no-passport">
                                    <i class="fas fa-exclamation-triangle"></i> Passeport non disponible
                                </span>
                            <% } %>
                        </div>
                    </div>
                    <% } %>
                </div>
            <% } else { %>
                <div style="text-align: center; padding: 50px; color: #666;">
                    <i class="fas fa-search" style="font-size: 4em; margin-bottom: 20px;"></i>
                    <h3>Aucun passager trouvé pour cette réservation</h3>
                </div>
            <% } %>
        </div>
    </div>
</body>
</html>
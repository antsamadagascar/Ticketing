<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="models.Reservation" %>
<%@ page import="models.Vol" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mes Réservations</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/mes-reservations.css" >
</head>
<body>
    <div class="container">
        <h2><i class="fas fa-ticket-alt"></i> Mes Réservations</h2>
       
        <%
            List<Reservation> reservations = (List<Reservation>) request.getAttribute("reservations");
            String messageSuccess = (String) request.getAttribute("messageSuccess");
            String messageError = (String) request.getAttribute("messageError");
            
            if (messageSuccess != null) {
        %>
            <div class="alert success"><i class="fas fa-check-circle"></i> <%= messageSuccess %></div>
        <% } %>
        
        <% if (messageError != null) { %>
            <div class="alert error"><i class="fas fa-exclamation-circle"></i> <%= messageError %></div>
        <% } %>

        <% if (reservations != null && !reservations.isEmpty()) { %>
        <table>
            <tr>
                <th><i class="fas fa-hashtag"></i> ID</th>
                <th><i class="fas fa-euro-sign"></i> Montant</th>
                <th><i class="far fa-calendar-alt"></i> Date Réservation</th>
                <th><i class="fas fa-plane"></i> N° Vol</th>
                <th><i class="fas fa-plane-departure"></i> Départ</th>
                <th><i class="fas fa-plane-arrival"></i> Arrivée</th>
                <th><i class="fas fa-users"></i> Passagers</th>
                <th><i class="fas fa-info-circle"></i> Statut</th>
                <th><i class="fas fa-cogs"></i> Actions</th>
            </tr>
            <%
                for (Reservation r : reservations) {
                    Vol vol = r.getVol();
            %>
            <tr>
                <td><%= r.getId() %></td>
                <td><%= r.getMontantTotal() %> €</td>
                <td><%= r.getDateReservation() %></td>
                <td><%= vol.getNumeroVol() %></td>
                <td><%= vol.getDateDepart() %></td>
                <td><%= vol.getDateArrivee() %></td>
                <td><%= r.getNombrePassager() %></td>
                <td>
                    <% if (r.isStatut()) { %>
                        <span class="status-confirmed">
                            <i class="fas fa-check-circle"></i> Confirmée
                        </span>
                    <% } else { %>
                        <span class="status-cancelled">
                            <i class="fas fa-times-circle"></i> Annulée
                        </span>
                    <% } %>
                </td>
                <td class="action-column">
                    <!-- Nouveau lien pour voir les passagers -->
                    <a href="/Ticketing/reservation/passagers?reservationId=<%= r.getId() %>&volId=<%= vol.getId() %>" class="passengers-btn" title="Voir les passagers">
                        <i class="fas fa-users"></i> Passagers
                    </a>
                    
                    <a href="http://localhost:8080/reservations/pdf/<%= r.getId() %>" class="pdf-btn" title="Télécharger PDF">
                        <i class="fas fa-file-pdf"></i> PDF
                    </a>
                    
                    <% if (r.isStatut()) { %>
                        <form action="/Ticketing/reservation/annuler" method="post" style="display: inline;">
                            <input type="hidden" name="reservationId" value="<%= r.getId() %>">
                            <button type="submit" class="cancel-btn" title="Annuler la réservation">
                                <i class="fas fa-ban"></i> Annuler
                            </button>
                        </form>
                    <% } %>
                </td>
            </tr>
            <% } %>
        </table>
        <% } else { %>
        <div class="no-reservations">
            <i class="fas fa-search"></i>
            <p>Aucune réservation trouvée.</p>
        </div>
        <% } %>
    </div>

    <script>
        // Add fade effect to alerts
        document.addEventListener('DOMContentLoaded', function() {
            const alerts = document.querySelectorAll('.alert');
            
            alerts.forEach(alert => {
                setTimeout(() => {
                    alert.style.transition = 'opacity 1s';
                    alert.style.opacity = '0';
                    setTimeout(() => {
                        alert.style.display = 'none';
                    }, 1000);
                }, 5000);
            });
        });
    </script>
</body>
</html>
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
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/reservation/mes-reservations.css" >
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
                <td><%= r.getMontantTotal() %> $</td>
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
                    
                   <!-- Nouveau bouton -->
                    <button class="pdf-btn" data-id="<%= r.getId() %>" data-user="${sessionScope.authUser.id}" title="Télécharger PDF">
                        <i class="fas fa-file-pdf"></i> PDF
                        <span class="download-status" style="display:none; margin-left:5px; font-style: italic; font-size: 0.9em;">Téléchargement...</span>
                    </button>

                    
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
        document.addEventListener('DOMContentLoaded', function() {
            // Fonction pour afficher un message d’alerte dynamique dans la page
            function showAlert(message, type = 'error') {
                let alertContainer = document.querySelector('.dynamic-alert');
                if (!alertContainer) {
                    alertContainer = document.createElement('div');
                    alertContainer.className = 'dynamic-alert';
                    alertContainer.style.position = 'fixed';
                    alertContainer.style.top = '10px';
                    alertContainer.style.right = '10px';
                    alertContainer.style.zIndex = '9999';
                    alertContainer.style.minWidth = '250px';
                    document.body.appendChild(alertContainer);
                }
    
                const alert = document.createElement('div');
                alert.textContent = message;
                alert.style.padding = '10px';
                alert.style.marginBottom = '10px';
                alert.style.borderRadius = '5px';
                alert.style.color = '#fff';
                alert.style.boxShadow = '0 2px 6px rgba(0,0,0,0.2)';
                alert.style.opacity = '1';
                alert.style.transition = 'opacity 1s ease';
    
                if (type === 'success') {
                    alert.style.backgroundColor = '#4CAF50'; // vert
                } else if (type === 'info') {
                    alert.style.backgroundColor = '#2196F3'; // bleu
                } else {
                    alert.style.backgroundColor = '#f44336'; // rouge
                }
    
                alertContainer.appendChild(alert);
    
                setTimeout(() => {
                    alert.style.opacity = '0';
                    setTimeout(() => alert.remove(), 1000);
                }, 5000);
            }
    
            // Fade out des alertes classiques existantes
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
    
            // Gestion du clic sur les boutons PDF
            const pdfButtons = document.querySelectorAll('.pdf-btn');
            pdfButtons.forEach(button => {
                button.addEventListener('click', function(e) {
                    e.preventDefault();
                    const reservationId = this.dataset.id;
                    console.log('Reservation ID:', reservationId);
    
                    if (!reservationId) {
                        showAlert("ID de réservation manquant.", "error");
                        return;
                    }
     
                    const userId = this.dataset.user;

                    const url = "http://localhost:8080/reservations/pdf/" + reservationId + "/" + userId;

                    showAlert("Téléchargement du PDF en cours...", "info");
    
                    fetch(url, {
                        method: 'GET',
                        headers: {
                            'Accept': 'application/pdf'
                        },
                        credentials: 'include'
                    })
                    .then(response => {
                        const contentType = response.headers.get('Content-Type') || '';
    
                        if (response.status === 401) {
                            throw new Error("Session expirée, veuillez vous reconnecter.");
                        }
    
                        if (!response.ok) {
                            throw new Error("Erreur lors de la récupération du PDF.");
                        }
    
                        // Si la réponse n'est pas un PDF,  redirection vers login
                        if (!contentType.includes('application/pdf')) {
                            throw new Error("Vous devez être connecté pour télécharger ce document.");
                        }
    
                        return response.blob();
                    })
                    .then(blob => {
                        const blobUrl = window.URL.createObjectURL(blob);
                        const a = document.createElement('a');
                        a.href = blobUrl;
                        a.download = `reservation_${reservationId}.pdf`;
                        document.body.appendChild(a);
                        a.click();
                        a.remove();
                        window.URL.revokeObjectURL(blobUrl);
                        showAlert("Téléchargement terminé.", "success");
                    })
                    .catch(error => {
                        showAlert(error.message, "error");
                    });
                });
            });
        });
    </script>
    
</body>
</html>
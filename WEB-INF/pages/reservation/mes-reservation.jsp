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
    <style>
        :root {
            --primary: #4a6fa5;
            --primary-dark: #365986;
            --secondary: #6c757d;
            --success: #28a745;
            --danger: #dc3545;
            --warning: #ffc107;
            --light: #f8f9fa;
            --dark: #343a40;
            --gray-100: #f8f9fa;
            --gray-200: #e9ecef;
            --gray-300: #dee2e6;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }


        .container {
            width: 90%;
            max-width: 1200px;
            margin: 30px auto;
            padding: 20px;
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 0 20px rgba(0, 0, 0, 0.05);
        }

        h2 {
            color: var(--primary);
            margin-bottom: 25px;
            padding-bottom: 10px;
            border-bottom: 2px solid var(--gray-200);
            text-align: center;
            font-size: 28px;
        }

        .alert {
            padding: 12px 15px;
            border-radius: 5px;
            margin-bottom: 20px;
            font-weight: 500;
        }

        .success {
            background-color: rgba(40, 167, 69, 0.1);
            color: var(--success);
            border-left: 4px solid var(--success);
        }

        .error {
            background-color: rgba(220, 53, 69, 0.1);
            color: var(--danger);
            border-left: 4px solid var(--danger);
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.05);
        }

        th, td {
            padding: 12px 15px;
            text-align: left;
            border-bottom: 1px solid var(--gray-300);
        }

        th {
            background-color: var(--primary);
            color: white;
            font-weight: 500;
        }

        tr:hover {
            background-color: var(--gray-100);
        }

        .no-reservations {
            text-align: center;
            padding: 40px 0;
            color: var(--secondary);
            font-size: 18px;
        }

        .cancel-btn {
            background-color: var(--danger);
            color: white;
            border: none;
            padding: 8px 12px;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.3s;
        }

        .cancel-btn:hover {
            background-color: #bd2130;
        }

        .pdf-btn {
            background-color: var(--primary);
            color: white;
            border: none;
            padding: 8px 12px;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.3s;
            text-decoration: none;
            display: inline-block;
            margin-right: 5px;
        }

        .pdf-btn:hover {
            background-color: var(--primary-dark);
        }

        .action-column {
            display: flex;
            gap: 5px;
        }

        .status-confirmed {
            color: var(--success);
            font-weight: 500;
        }

        .status-cancelled {
            color: var(--danger);
            font-weight: 500;
        }

        @media (max-width: 1024px) {
            .container {
                width: 95%;
                padding: 15px;
            }
            
            table {
                display: block;
                overflow-x: auto;
            }
        }

        @media (max-width: 768px) {
            th, td {
                padding: 10px;
            }
            
            h2 {
                font-size: 24px;
            }
        }
    </style>
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
                    <a href="http://localhost:8080/reservations/pdf/<%= r.getId() %>" class="pdf-btn" title="Télécharger PDF">
                        <i class="fas fa-file-pdf"></i> PDF
                    </a>
                    <% if (r.isStatut()) { %>
                        <form action="/Ticketing/reservation/annuler" method="post">
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
<<<<<<< Updated upstream
        <%
            } else {
        %>
        <p class="no-reservations">Aucune réservation trouvée.</p>
        <%
            }
        %>
    </div>
=======
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
>>>>>>> Stashed changes

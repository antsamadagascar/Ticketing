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

    <style>
        :root {
            --primary: #3a7bd5;
            --primary-light: #4d90fe;
            --secondary: #00d2ff;
            --dark: #333;
            --light: #f8f9fa;
            --danger: #e74c3c;
            --success: #2ecc71;
            --warning: #f39c12;
            --gray-light: #f1f1f1;
            --gray: #ddd;
            --shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }
        
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
 
        
        h2 {
            color: var(--primary);
            margin-bottom: 30px;
            font-weight: 600;
            text-align: center;
            position: relative;
            padding-bottom: 15px;
        }
        
        h2:after {
            content: '';
            position: absolute;
            left: 50%;
            bottom: 0;
            transform: translateX(-50%);
            height: 4px;
            width: 60px;
            background: linear-gradient(to right, var(--primary), var(--secondary));
            border-radius: 2px;
        }
        
        .alert {
            padding: 15px;
            margin: 20px 0;
            border-radius: 8px;
            display: flex;
            align-items: center;
            font-weight: 500;
        }
        
        .alert:before {
            margin-right: 10px;
            font-family: 'Font Awesome 6 Free';
            font-weight: 900;
        }
        
        .success {
            background-color: rgba(46, 204, 113, 0.2);
            border-left: 4px solid var(--success);
            color: #27ae60;
        }
        
        .success:before {
            content: '\f058'; /* check-circle */
        }
        
        .error {
            background-color: rgba(231, 76, 60, 0.2);
            border-left: 4px solid var(--danger);
            color: #c0392b;
        }
        
        .error:before {
            content: '\f06a'; /* exclamation-circle */
        }
        
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
            box-shadow: 0 2px 3px rgba(0, 0, 0, 0.05);
            overflow: hidden;
            border-radius: 8px;
        }
        
        th, td {
            padding: 16px;
            text-align: left;
            border-bottom: 1px solid var(--gray);
        }
        
        th {
            background-color: var(--primary);
            color: white;
            font-weight: 500;
            text-transform: uppercase;
            font-size: 0.85rem;
            letter-spacing: 0.5px;
        }
        
        tr:nth-child(even) {
            background-color: var(--gray-light);
        }
        
        tr:hover {
            background-color: rgba(58, 123, 213, 0.1);
        }
        
        img {
            border-radius: 6px;
            border: 2px solid var(--gray);
            transition: transform 0.3s ease;
            object-fit: cover;
        }
        
        img:hover {
            transform: scale(1.1);
        }
        
        .cancel-btn {
            background-color: var(--danger);
            color: white;
            border: none;
            padding: 8px 16px;
            border-radius: 6px;
            cursor: pointer;
            transition: background-color 0.2s;
            font-weight: 500;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        .cancel-btn:before {
            content: '\f2ed'; /* trash-alt */
            font-family: 'Font Awesome 6 Free';
            font-weight: 900;
            margin-right: 8px;
        }
        
        .cancel-btn:hover {
            background-color: #c0392b;
        }
        
        .no-reservations {
            text-align: center;
            padding: 40px;
            color: #7f8c8d;
            font-size: 1.2rem;
        }
        
        .no-reservations:before {
            content: '\f187'; /* archive */
            font-family: 'Font Awesome 6 Free';
            font-weight: 900;
            display: block;
            font-size: 3rem;
            margin-bottom: 15px;
            color: var(--gray);
        }
        
        @media screen and (max-width: 992px) {
            .container {
                padding: 20px;
            }
            
            table {
                display: block;
                overflow-x: auto;
                white-space: nowrap;
            }
            
            th, td {
                padding: 12px;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>Mes Réservations</h2>
       
        <%
            List<Reservation> reservations = (List<Reservation>) request.getAttribute("reservations");
            if (reservations != null && !reservations.isEmpty()) {
        %>
        <% String messageSuccess = (String) request.getAttribute("messageSuccess"); %>
        <% String messageError = (String) request.getAttribute("messageError"); %>
        <% if (messageSuccess != null) { %>
            <div class="alert success"><%= messageSuccess %></div>
        <% } %>
        <% if (messageError != null) { %>
            <div class="alert error"><%= messageError %></div>
        <% } %>
        <table>
            <tr>
                <th>ID Réservation</th>
                <th>Montant Total</th>
                <th>Date de Réservation</th>
                <th>Statut</th>
                <th>Numéro de Vol</th>
                <th>Date Départ</th>
                <th>Date Arrivée</th>
                <th>Passeport</th>
                <th>Action</th>
            </tr>
            <%
                for (Reservation r : reservations) {
                    Vol vol = r.getVol();
            %>
            <tr>
                <td><%= r.getId() %></td>
                <td><%= r.getMontantTotal() %> €</td>
                <td><%= r.getDateReservation() %></td>
                <td>
                    <% if (r.isStatut()) { %>
                        <span style="color: var(--success); font-weight: 500;">
                            <i class="fas fa-check-circle"></i> Confirmée
                        </span>
                    <% } else { %>
                        <span style="color: var(--danger); font-weight: 500;">
                            <i class="fas fa-times-circle"></i> Annulée
                        </span>
                    <% } %>
                </td>
                <td><%= vol.getNumeroVol() %></td>
                <td><%= vol.getDateDepart() %></td>
                <td><%= vol.getDateArrivee() %></td>
                <td>
                    <% if (r.getPassFileUpload() != null) { %>
                        <img src="<%= r.getPassFileUpload() != null ? r.getPassFileUpload().getFilePath() : "" %>" width="100" height="100" alt="Passeport">
                    <% } else { %>
                        <span style="color: var(--warning);">
                            <i class="fas fa-exclamation-triangle"></i> Aucun passeport
                        </span>
                    <% } %>
                </td>
                <td>
                    <% if (r.isStatut()) { %>
                        <form action="/Ticketing/reservation/annuler" method="post">
                            <input type="hidden" name="reservationId" value="<%= r.getId() %>">
                            <button type="submit" class="cancel-btn">Annuler</button>
                        </form>
                    <% } %>
                </td>
            </tr>
            <%
                }
            %>
        </table>
        <%
            } else {
        %>
        <p class="no-reservations">Aucune réservation trouvée.</p>
        <%
            }
        %>
    </div>
</body>
</html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="models.Ville" %>
<%@ page import="models.TypeSiege" %>
<%@ page import="models.VolMulticritereResult" %>
<%
    java.time.LocalDateTime now = java.time.LocalDateTime.now();
    java.time.format.DateTimeFormatter formatter = java.time.format.DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm");
    String dateTimeNow = now.format(formatter);
%>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Recherche de Vols</title>
    <style>
        :root {
            --primary: #4361ee;
            --primary-light: #4895ef;
            --secondary: #3f37c9;
            --accent: #f72585;
            --light: #f8f9fa;
            --dark: #212529;
            --success: #2ecc71;
            --warning: #f39c12;
            --danger: #e74c3c;
            --gray-100: #f8f9fa;
            --gray-200: #e9ecef;
            --gray-300: #dee2e6;
            --gray-400: #ced4da;
            --gray-500: #adb5bd;
            --gray-700: #495057;
            --gray-900: #212529;
            --shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            --shadow-lg: 0 10px 15px rgba(0, 0, 0, 0.1);
            --radius: 8px;
        }
        
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        
        .container {
            max-width: 1200px;
            margin: 0 auto;
            margin-top: 50px;
        }
        
        .header {
            text-align: center;
            margin-bottom: 2rem;
        }
        
        .header h1 {
            color: var(--primary);
            font-size: 2.5rem;
            font-weight: 700;
            margin-bottom: 0.5rem;
        }
        
        .header p {
            color: var(--gray-700);
            font-size: 1.1rem;
        }
        
        .card {
            background-color: white;
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            overflow: hidden;
            margin-bottom: 2rem;
            transition: transform 0.2s, box-shadow 0.2s;
        }
        
        .card:hover {
            transform: translateY(-5px);
            box-shadow: var(--shadow-lg);
        }
        
        .card-header {
            background: linear-gradient(to right, var(--primary), var(--primary-light));
            color: white;
            padding: 1.25rem 1.5rem;
            font-weight: 600;
            font-size: 1.25rem;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
        
        .card-header i {
            margin-right: 0.75rem;
        }
        
        .card-body {
            padding: 1.5rem;
        }
        
        .form-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 1.25rem;
        }
        
        .form-group {
            margin-bottom: 1rem;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 0.5rem;
            color: var(--gray-700);
            font-weight: 500;
        }
        
        .form-control {
            width: 100%;
            padding: 0.75rem 1rem;
            font-size: 1rem;
            border: 1px solid var(--gray-300);
            border-radius: var(--radius);
            background-color: var(--light);
            transition: border-color 0.15s, box-shadow 0.15s;
        }
        
        .form-control:focus {
            border-color: var(--primary-light);
            box-shadow: 0 0 0 3px rgba(67, 97, 238, 0.25);
            outline: none;
        }
        
        .btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            padding: 0.75rem 1.25rem;
            font-size: 1rem;
            font-weight: 500;
            text-align: center;
            text-decoration: none;
            border: none;
            border-radius: var(--radius);
            cursor: pointer;
            transition: all 0.2s;
        }
        
        .btn-primary {
            background-color: var(--primary);
            color: white;
        }
        
        .btn-primary:hover {
            background-color: var(--secondary);
        }
        
        .btn-secondary {
            background-color: var(--gray-400);
            color: var(--gray-900);
        }
        
        .btn-secondary:hover {
            background-color: var(--gray-500);
        }
        
        .btn i {
            margin-right: 0.5rem;
        }
        
        .table-container {
            overflow-x: auto;
        }
        
        table {
            width: 100%;
            border-collapse: collapse;
        }
        
        thead {
            background-color: var(--gray-200);
        }
        
        th {
            padding: 1rem;
            text-align: left;
            font-weight: 600;
            color: var(--gray-700);
            text-transform: uppercase;
            font-size: 0.75rem;
            letter-spacing: 0.5px;
        }
        
        td {
            padding: 1rem;
            border-bottom: 1px solid var(--gray-200);
            color: var(--gray-900);
        }
        
        tr:hover {
            background-color: var(--gray-100);
        }
        
        .badge {
            display: inline-flex;
            align-items: center;
            padding: 0.35rem 0.65rem;
            font-size: 0.75rem;
            font-weight: 600;
            line-height: 1;
            border-radius: 50rem;
        }
        
        .badge-success {
            background-color: rgba(46, 204, 113, 0.2);
            color: #27ae60;
        }
        
        .badge-secondary {
            background-color: var(--gray-200);
            color: var(--gray-700);
        }
        
        .toggle-form {
            cursor: pointer;
        }
        
        .hidden {
            display: none;
        }
        
        .empty-results {
            text-align: center;
            padding: 3rem 1.5rem;
        }
        
        .empty-results i {
            font-size: 3rem;
            color: var(--gray-400);
            margin-bottom: 1rem;
        }
        
        .empty-results h3 {
            font-size: 1.5rem;
            color: var(--gray-700);
            margin-bottom: 1rem;
        }
        
        .empty-results p {
            color: var(--gray-500);
            margin-bottom: 1.5rem;
        }
        
        .city-pair {
            display: flex;
            align-items: center;
            font-weight: 500;
        }
        
        .city-pair i {
            margin: 0 0.5rem;
            color: var(--gray-500);
        }
        
        .price-range {
            font-weight: 600;
            color: var(--primary);
        }
        
        /* Animation */
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
        
        .fade-in {
            animation: fadeIn 0.3s ease-out forwards;
        }
        
        .actions {
            display: flex;
            justify-content: flex-end;
            gap: 0.5rem;
        }
        
        /* Responsive */
        @media (max-width: 768px) {
            .form-grid {
                grid-template-columns: 1fr;
            }
            
            .card-header {
                padding: 1rem;
                font-size: 1.1rem;
            }
            
            .card-body {
                padding: 1.25rem;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>Trouvez votre vol idéal</h1>
            <p>Recherchez parmi nos destinations et trouvez le vol qui vous convient</p>
        </div>
        
        <div class="card fade-in">
            <div id="search-header" class="card-header toggle-form">
                <div>
                    <i class="fas fa-search"></i> Critères de recherche
                </div>
                <i id="toggle-icon" class="fas fa-chevron-down"></i>
            </div>
            
            <div id="search-form" class="card-body">
                <form action="${pageContext.request.contextPath}/recherche/resultats" method="post">
                    <div class="form-grid">
                        <div class="form-group">
                            <label for="villeDepart">
                                <i class="fas fa-plane-departure"></i> Ville de départ
                            </label>
                            <select class="form-control" id="villeDepart" name="villeDepartId">
                                <% for (Ville ville : (List<Ville>) request.getAttribute("villes")) { %>
                                    <option value="<%= ville.getId() %>"><%= ville.getNom() %></option>
                                <% } %>
                            </select>
                        </div>
                        
                        <div class="form-group">
                            <label for="villeArrivee">
                                <i class="fas fa-plane-arrival"></i> Ville d'arrivée
                            </label>
                            <select class="form-control" id="villeArrivee" name="villeArriveeId">
                                <% for (Ville ville : (List<Ville>) request.getAttribute("villes")) { %>
                                    <option value="<%= ville.getId() %>"><%= ville.getNom() %></option>
                                <% } %>
                            </select>
                        </div>
                        
                        <div class="form-group">
                            <label for="dateDepart">
                                <i class="fas fa-calendar-alt"></i> Date de départ
                            </label>
                            <input type="datetime-local" class="form-control" id="dateDepart" name="dateDepart"
                                   value="<%= dateTimeNow %>">
                        </div>
                        
                        
                        
                        <div class="form-group">
                            <label for="typeSiege">
                                <i class="fas fa-chair"></i> Type de siège
                            </label>
                            <select class="form-control" id="typeSiege" name="typeSiegeId">
                                <% for (TypeSiege type : (List<TypeSiege>) request.getAttribute("typesSiege")) { %>
                                    <option value="<%= type.getId() %>"><%= type.getNom() %></option>
                                <% } %>
                            </select>
                        </div>
                        
                        <div class="form-group">
                            <label for="prixMin">
                                <i class="fas fa-tag"></i> Prix minimum
                            </label>
                            <input type="number" class="form-control" id="prixMin" name="prixMin" step="0.01" min="0">
                        </div>
                        
                        <div class="form-group">
                            <label for="prixMax">
                                <i class="fas fa-tags"></i> Prix maximum
                            </label>
                            <input type="number" class="form-control" id="prixMax" name="prixMax" step="0.01" min="0">
                        </div>
                        
                        <div class="form-group">
                            <label for="nombrePassagers">
                                <i class="fas fa-users"></i> Nombre de passagers
                            </label>
                            <input type="number" class="form-control" id="nombrePassagers" name="nombrePassagers" min="1" value="1">
                        </div>
                    </div>
                    
                    <div class="actions">
                        <button type="reset" class="btn btn-secondary">
                            <i class="fas fa-redo"></i> Réinitialiser
                        </button>
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-search"></i> Rechercher
                        </button>
                    </div>
                </form>
            </div>
        </div>
        
        <% if (request.getAttribute("vols") != null) { %>
            <div class="card fade-in">
                <div class="card-header">
                    <i class="fas fa-list-ul"></i> Résultats de la recherche
                </div>
                <div class="card-body">
                    <% List<VolMulticritereResult> vols = (List<VolMulticritereResult>) request.getAttribute("vols"); %>
                    <% if (!vols.isEmpty()) { %>
                        <div class="table-container">
                            <table>
                                <thead>
                                    <tr>
                                        <th>N° Vol</th>
                                        <th>Trajet</th>
                                        <th>Départ</th>
                                        <th>Arrivée</th>
                                        <th>Type de siège</th>
                                        <th>Prix(€)</th>
                                        <th>Nombre siège disponible</th>
                                        <th>Promotion</th>
                                         <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% for (VolMulticritereResult vol : vols) { %>
                                        <tr>
                                            <td><strong><%= vol.getNumeroVol() %></strong></td>
                                            <td>
                                                <div class="city-pair">
                                                    <%= vol.getVilleDepart().getNom() %>
                                                    <i class="fas fa-long-arrow-alt-right"></i>
                                                    <%= vol.getVilleArrivee().getNom() %>
                                                </div>
                                            </td>
                                            <td><%= vol.getDateDepart() %></td>
                                            <td><%= vol.getDateArrivee() %></td>
                                            <td><%= vol.getTypeSiege().getNom() %></td>
                                            <td>
                                                <span class="price-range">
                                                    <%= vol.getPrixMinimum() %> - <%= vol.getPrixMaximum() %>
                                                </span>
                                            </td>
                                            <td> <%= vol.getNombreSiegesDisponibles() %></td>
                                            <td>
                                                <%
                                                    Boolean estEnPromo = vol.isEstEnPromotion();
                                                    if (estEnPromo != null && estEnPromo) {
                                                %>
                                                    <span class="badge badge-success">
                                                       En promotion
                                                    </span>
                                                <%
                                                    } else {
                                                %>
                                                    <span class="badge badge-secondary">Pas en promotion</span>
                                                <%
                                                    }
                                                %>
                                            </td>
                                           <td>
                                                <a href="${pageContext.request.contextPath}/reservation-vol" class="btn btn-primary  style="padding: 0.5rem 0.75rem; font-size: 0.875rem;">
                                                    <i class="fas fa-ticket-alt"></i> reservation 
                                                </a>
                                            </td>
                                       
                                        </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                    <% } else { %>
                        <div class="empty-results">
                            <i class="fas fa-search"></i>
                            <h3>Aucun vol trouvé</h3>
                            <p>Essayez d'élargir votre recherche en modifiant les critères.</p>
                            <button id="modify-search" class="btn btn-primary">
                                <i class="fas fa-edit"></i> Modifier la recherche
                            </button>
                        </div>
                    <% } %>
                </div>
            </div>
        <% } %>
    </div>
    
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Fonction pour basculer l'affichage du formulaire
            const searchHeader = document.getElementById('search-header');
            const searchForm = document.getElementById('search-form');
            const toggleIcon = document.getElementById('toggle-icon');
            
            if (searchHeader && searchForm && toggleIcon) {
                // Si des résultats sont affichés, masquer le formulaire par défaut
                <% if (request.getAttribute("vols") != null) { %>
                    searchForm.classList.add('hidden');
                    toggleIcon.classList.remove('fa-chevron-down');
                    toggleIcon.classList.add('fa-chevron-up');
                <% } %>
                
                searchHeader.addEventListener('click', function() {
                    searchForm.classList.toggle('hidden');
                    toggleIcon.classList.toggle('fa-chevron-down');
                    toggleIcon.classList.toggle('fa-chevron-up');
                });
            }
            
            // Bouton pour modifier la recherche
            const modifySearchBtn = document.getElementById('modify-search');
            if (modifySearchBtn) {
                modifySearchBtn.addEventListener('click', function() {
                    searchForm.classList.remove('hidden');
                    toggleIcon.classList.remove('fa-chevron-up');
                    toggleIcon.classList.add('fa-chevron-down');
                    searchHeader.scrollIntoView({ behavior: 'smooth' });
                });
            }
            
            // Validation de la date de départ (ne pas permettre des dates passées)
            const dateDepart = document.getElementById('dateDepart');
            if (dateDepart) {
                const now = new Date();
                const year = now.getFullYear();
                const month = String(now.getMonth() + 1).padStart(2, '0');
                const day = String(now.getDate()).padStart(2, '0');
                const hours = String(now.getHours()).padStart(2, '0');
                const minutes = String(now.getMinutes()).padStart(2, '0');
                const minDateTime = `${year}-${month}-${day}T${hours}:${minutes}`;
                
                dateDepart.setAttribute('min', minDateTime);
                
                // Si pas de date définie, définir la date par défaut à aujourd'hui
                if (!dateDepart.value) {
                    dateDepart.value = minDateTime;
                }
            }
            
            // Validation des villes (départ != arrivée)
            const villeDepart = document.getElementById('villeDepart');
            const villeArrivee = document.getElementById('villeArrivee');
            
            if (villeDepart && villeArrivee) {
                // S'assurer que la ville d'arrivée est différente de la ville de départ
                villeDepart.addEventListener('change', function() {
                    if (villeDepart.value === villeArrivee.value) {
                        // Trouver une autre ville
                        for (let i = 0; i < villeArrivee.options.length; i++) {
                            if (villeArrivee.options[i].value !== villeDepart.value) {
                                villeArrivee.value = villeArrivee.options[i].value;
                                break;
                            }
                        }
                    }
                });
                
                villeArrivee.addEventListener('change', function() {
                    if (villeArrivee.value === villeDepart.value) {
                        alert('La ville d\'arrivée doit être différente de la ville de départ.');
                        // Réinitialiser à la valeur précédente ou trouver une autre ville
                        for (let i = 0; i < villeArrivee.options.length; i++) {
                            if (villeArrivee.options[i].value !== villeDepart.value) {
                                villeArrivee.value = villeArrivee.options[i].value;
                                break;
                            }
                        }
                    }
                });
                
                // S'assurer que les villes initiales sont différentes
                if (villeDepart.value === villeArrivee.value && villeArrivee.options.length > 1) {
                    villeArrivee.value = villeArrivee.options[1].value;
                }
            }
        });
    </script>
</body>
</html>
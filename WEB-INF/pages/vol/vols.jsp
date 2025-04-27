<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    java.time.LocalDateTime now = java.time.LocalDateTime.now();
    java.time.LocalDateTime arrivee = now.plusHours(3);
    java.time.format.DateTimeFormatter formatter = java.time.format.DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm");

    String dateDepart = request.getAttribute("dateDepart") != null ? (String) request.getAttribute("dateDepart") : now.format(formatter);
    String dateArrivee = request.getAttribute("dateArrivee") != null ? (String) request.getAttribute("dateArrivee") : arrivee.format(formatter);
%>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestion des Vols - SkyManager</title>
</head>
<link href="<%= request.getContextPath() %>/assets/css/vols/vols.css" rel="stylesheet"> 
<body>
    <!-- En-tête -->
    <header class="header">
        <div class="header-content">
            <div class="logo-container">
                <i class="fas fa-plane logo-icon"></i>
                <h1 class="logo-text">SkyManager</h1>
            </div>
         
        </div>
    </header>

    <div class="container">
        <!-- Section liste des vols -->
        <div class="section-flights">
            <div class="section-title">
                <h2><i class="fas fa-list-ul"></i> Liste des Vols</h2>
            </div>

            <div class="card">
                <div class="table-container">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th><div>ID </div></th>
                                <th><div>Numéro Vol </div></th>
                                <th><div>Trajet </div></th>
                                <th><div>Départ </div></th>
                                <th><div>Arrivée </div></th>
                                <th><div>Avion </div></th>
                                <th><div>Statut </div></th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                java.util.List<models.Vol> vols = (java.util.List<models.Vol>) request.getAttribute("vols");
                                if (vols != null) {
                                    for (models.Vol vol : vols) {
                            %>
                                <tr>
                                    <td class="vol-id">#<%= vol.getId() %></td>
                                    <td class="vol-numero"><%= vol.getNumeroVol() %></td>
                                    <td>
                                        <div class="vol-trajet">
                                            <span><%= vol.getVilleDepart().getNom() %></span>
                                            <i class="fas fa-plane trajet-icon"></i>
                                            <span><%= vol.getVilleArrivee().getNom() %></span>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="vol-date">
                                            <span class="date-time"><%= vol.getDateDepart().toString().substring(11, 16) %></span>
                                            <span class="date-day"><%= vol.getDateDepart().toString().substring(0, 10) %></span>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="vol-date">
                                            <span class="date-time"><%= vol.getDateArrivee().toString().substring(11, 16) %></span>
                                            <span class="date-day"><%= vol.getDateArrivee().toString().substring(0, 10) %></span>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="vol-avion">
                                            <i class="fas fa-plane avion-icon"></i>
                                            <span><%= vol.getAvion().getModele() %></span>
                                        </div>
                                    </td>
                                    <td>
                                        <% 
                                            String statutText = "Inconnu";
                                            String statutClass = "";
                                            String statutIcon = "";
                                            
                                            if (vol.getStatut() == 0) {
                                                statutText = "Programmé";
                                                statutClass = "status-scheduled";
                                                statutIcon = "fa-clock";
                                            } else if (vol.getStatut() == -1) {
                                                statutText = "Annulé";
                                                statutClass = "status-cancelled";
                                                statutIcon = "fa-ban";
                                            } else if (vol.getStatut() == 1) {
                                                statutText = "Terminé";
                                                statutClass = "status-completed";
                                                statutIcon = "fa-check-circle";
                                            }
                                        %>
                                        <span class="status-badge <%= statutClass %>">
                                            <i class="fas <%= statutIcon %>"></i> <%= statutText %>
                                        </span>
                                    </td>
                                    <td>
                                        <div class="actions">
                                            <a href="${pageContext.request.contextPath}/vols/edit?id=<%= vol.getId() %>" class="btn-action btn-edit" title="Modifier">
                                                <i class="fas fa-edit"></i>
                                            </a>
                                            <a href="${pageContext.request.contextPath}/vols/delete?id=<%= vol.getId() %>" class="btn-action btn-delete" title="Supprimer" onclick="return confirm('Confirmer la suppression ?')">
                                                <i class="fas fa-trash-alt"></i>
                                            </a>
                                            <!--
                                            <a href="#" class="btn-action btn-more" title="Plus d'options">
                                                <i class="fas fa-ellipsis-v"></i>
                                            </a>
                                        --> 
                                        </div>
                                    </td>
                                </tr>
                            <%
                                    }
                                }
                            %>
                        </tbody>
                    </table>
                </div>
                <!--
                <div class="table-footer">
                    <p class="pagination-info">
                        Affichage de <span class="bold">1</span> à <span class="bold">
                        <% if (vols != null) { %>
                            <%= vols.size() %>
                        <% } else { %>
                            0
                        <% } %>
                        </span> vols
                    </p>
                    <div class="pagination">
                        <button disabled class="pagination-btn pagination-btn-disabled">
                            <i class="fas fa-chevron-left"></i>
                        </button>
                        <button class="pagination-btn pagination-btn-active">
                            1
                        </button>
                        <button class="pagination-btn">
                            2
                        </button>
                        <button class="pagination-btn">
                            <i class="fas fa-chevron-right"></i>
                        </button>
                    </div>
                </div>
            -->
            </div>
        </div>

        <!-- Formulaire d'ajout d'un vol -->
        <div class="card">
            <div class="card-header">
                <h2><i class="fas fa-plus-circle"></i> Ajouter un nouveau vol</h2>
            </div>

            <% String successMessage = (String) request.getAttribute("successMessage"); %>
            <% if (successMessage != null) { %>
                <div class="success-message">
                    <i class="fas fa-check-circle"></i>
                    <p><%= successMessage %></p>
                </div>
            <% } %>

            <div class="form-container">
                <form action="${pageContext.request.contextPath}/vols/add" method="post">
                    <div class="form-grid">
                        <div class="form-group">
                            <label class="form-label">
                                <i class="fas fa-hashtag"></i> Numéro Vol
                            </label>
                            <input type="text" name="numeroVol" value="<%= request.getAttribute("numeroVol") != null ? request.getAttribute("numeroVol") : "" %>" 
                                class="form-control">
                            <% if (request.getAttribute("numeroVolError") != null) { %>
                                <p class="error-message">
                                    <i class="fas fa-exclamation-circle"></i>
                                    <%= request.getAttribute("numeroVolError") %>
                                </p>
                            <% } %>
                        </div>

                        <div class="form-group">
                            <label class="form-label">
                                <i class="fas fa-plane-departure"></i> Ville Départ
                            </label>
                            <div class="form-select-container">
                                <select name="villeDepartId" class="form-select">
                                    <%
                                        java.util.List<models.Ville> villes = (java.util.List<models.Ville>) request.getAttribute("villes");
                                        Integer selectedVilleDepart = (Integer) request.getAttribute("villeDepartId");
                                        if (villes != null) {
                                            for (models.Ville ville : villes) {
                                                boolean isSelected = selectedVilleDepart != null && selectedVilleDepart == ville.getId();
                                    %>
                                                <option value="<%= ville.getId() %>" <%= isSelected ? "selected" : "" %>><%= ville.getNom() %></option>
                                    <%
                                            }
                                        }
                                    %>
                                </select>
                                <i class="fas fa-chevron-down select-icon"></i>
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <label class="form-label">
                                <i class="fas fa-plane-arrival"></i> Ville Arrivée
                            </label>
                            <div class="form-select-container">
                                <select name="villeArriveeId" class="form-select">
                                    <%
                                        Integer selectedVilleArrivee = (Integer) request.getAttribute("villeArriveeId");
                                        if (villes != null) {
                                            for (models.Ville ville : villes) {
                                                boolean isSelected = selectedVilleArrivee != null && selectedVilleArrivee == ville.getId();
                                    %>
                                                <option value="<%= ville.getId() %>" <%= isSelected ? "selected" : "" %>><%= ville.getNom() %></option>
                                    <%
                                            }
                                        }
                                    %>
                                </select>
                                <i class="fas fa-chevron-down select-icon"></i>
                            </div>
                            <% if (request.getAttribute("villeArriveeIdError") != null) { %>
                                <p class="error-message">
                                    <i class="fas fa-exclamation-circle"></i>
                                    <%= request.getAttribute("villeArriveeIdError") %>
                                </p>
                            <% } %>
                        </div>

                        <div class="form-group">
                            <label class="form-label">
                                <i class="far fa-calendar-alt"></i> Date Départ
                            </label>
                            <input type="datetime-local" name="dateDepart" value="<%= dateDepart %>" class="form-control">
                            <% if (request.getAttribute("dateDepartError") != null) { %>
                                <p class="error-message">
                                    <i class="fas fa-exclamation-circle"></i>
                                    <%= request.getAttribute("dateDepartError") %>
                                </p>
                            <% } %>
                        </div>

                        <div class="form-group">
                            <label class="form-label">
                                <i class="far fa-calendar-check"></i> Date Arrivée
                            </label>
                            <input type="datetime-local" name="dateArrivee" value="<%= dateArrivee %>" class="form-control">
                            <% if (request.getAttribute("dateArriveeError") != null) { %>
                                <p class="error-message">
                                    <i class="fas fa-exclamation-circle"></i>
                                    <%= request.getAttribute("dateArriveeError") %>
                                </p>
                            <% } %>
                        </div>

                        <div class="form-group">
                            <label class="form-label">
                                <i class="fas fa-fighter-jet"></i> Avion
                            </label>
                            <div class="form-select-container">
                                <select name="avionId" class="form-select">
                                    <%
                                        java.util.List<models.Avion> avions = (java.util.List<models.Avion>) request.getAttribute("avions");
                                        Integer selectedAvion = (Integer) request.getAttribute("avionId");
                                        if (avions != null) {
                                            for (models.Avion avion : avions) {
                                                boolean isSelected = selectedAvion != null && selectedAvion == avion.getId();
                                    %>
                                                <option value="<%= avion.getId() %>" <%= isSelected ? "selected" : "" %>><%= avion.getModele() %></option>
                                    <%
                                            }
                                        }
                                    %>
                                </select>
                                <i class="fas fa-chevron-down select-icon"></i>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="form-label">
                                <i class="fas fa-info-circle"></i> Statut
                            </label>
                            <div class="form-select-container">
                                <select name="statut" class="form-select">
                                    <% 
                                        Integer selectedStatut = (Integer) request.getAttribute("statut");

                                        String[] statuts = {"0", "1", "-1"};
                                        String[] statutsLabel = {"Programmé", "Terminé", "Annulé"};
                                        
                                        for (int i = 0; i < statuts.length; i++) {
                                            boolean isSelected = selectedStatut != null && selectedStatut.equals(Integer.parseInt(statuts[i]));
                                    %>
                                            <option value="<%= statuts[i] %>" <%= isSelected ? "selected" : "" %>>
                                                <%= statutsLabel[i] %>
                                            </option>
                                    <%
                                        }
                                    %>
                                </select>
                                <i class="fas fa-chevron-down select-icon"></i>
                            </div>
                            <% if (request.getAttribute("statutError") != null) { %>
                                <p class="error-message">
                                    <i class="fas fa-exclamation-circle"></i>
                                    <%= request.getAttribute("statutError") %>
                                </p>
                            <% } %>
                        </div>
                    </div>

                    <div class="form-footer">
                        <button type="button" class="btn btn-cancel">
                            Annuler
                        </button>
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-paper-plane"></i>
                            Ajouter le vol
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script>
        // Script pour confirmer la suppression
        document.addEventListener('DOMContentLoaded', function() {
            const deleteLinks = document.querySelectorAll('a[href*="/vols/delete"]');
            deleteLinks.forEach(link => {
                link.addEventListener('click', function(e) {
                    if (!confirm('Êtes-vous sûr de vouloir supprimer ce vol ?')) {
                        e.preventDefault();
                    }
                });
            });
        });
    </script>
</body>
</html>
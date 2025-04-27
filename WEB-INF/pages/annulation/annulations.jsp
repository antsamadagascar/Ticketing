<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.Map" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestion des Règles d'Annulation</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/vols/annulation-vol.css">
</head>
<body>
    <div class="page-container">
        <!-- Titre de la page avec gradient header -->
        <div class="header-gradient mb-8">
            <h2 class="text-3xl font-bold flex items-center">
                <i class="fas fa-calendar-times mr-3 text-2xl"></i>
                Gestion des Règles d'Annulation
            </h2>
            <p class="text-red-50 mt-2">Configuration des délais autorisés pour l'annulation des réservations</p>
        </div>

        <!-- Message de succès -->
        <% String successMessage = (String) request.getAttribute("successMessage"); %>
        <% if (successMessage != null) { %>
            <div class="alert alert-success">
                <i class="fas fa-check-circle text-green-500 text-xl mr-3"></i>
                <span><%= successMessage %></span>
            </div>
        <% } %>

        <!-- Affichage des erreurs -->
        <% Map<String, String> errors = (Map<String, String>) request.getAttribute("errors"); %>
        <% if (errors != null && !errors.isEmpty()) { %>
            <div class="alert alert-error">
                <i class="fas fa-exclamation-circle text-red-500 text-xl mr-3"></i>
                <ul>
                    <% for (Map.Entry<String, String> entry : errors.entrySet()) { %>
                        <li><%= entry.getValue() %></li>
                    <% } %>
                </ul>
            </div>
        <% } %>

        <!-- Tableau des règles -->
        <div class="card bg-white mb-10" > 
            <div class="p-5 border-b border-gray-200">
                <h3 class="text-xl font-semibold text-gray-800">Liste des règles d'annulation</h3>
                <p class="text-gray-500 text-sm mt-1">Consultez et modifiez les règles d'annulation actuelles</p>
            </div>
            
            <div class="table-container">
                <table class="min-w-full">
                    <thead>
                        <tr>
                            <th class="text-left">Heures après réservation</th>
                            <th class="text-left">Statut</th>
                            <th class="text-left">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% 
                            java.util.List<models.RegleAnnulation> regles = (java.util.List<models.RegleAnnulation>) request.getAttribute("regles");
                            boolean hasRegles = regles != null && !regles.isEmpty();
                            
                            if (hasRegles) {
                                for (models.RegleAnnulation regle : regles) {
                        %>
                        <tr class="hover:bg-gray-50 transition duration-200">
                            <td class="text-gray-800 font-medium">
                                <div class="flex items-center">
                                    <i class="fas fa-hourglass-half text-red-400 mr-2"></i>
                                    <%= regle.getHeuresApresReservation() %> heures
                                </div>
                            </td>
                            <td>
                                <% if (regle.isActive()) { %>
                                    <span class="status-badge status-active">
                                        <i class="fas fa-check-circle mr-1"></i> Active
                                    </span>
                                <% } else { %>
                                    <span class="status-badge status-inactive">
                                        <i class="fas fa-times-circle mr-1"></i> Inactive
                                    </span>
                                <% } %>
                            </td>
                            <td>
                                <a href="${pageContext.request.contextPath}/regles-annulation/edit?id=<%= regle.getId() %>" class="icon-button icon-button-edit">
                                    <i class="fas fa-edit mr-2"></i>Modifier
                                </a>
                            </td>
                        </tr>
                        <% } } else { %>
                        <tr>
                            <td colspan="3">
                                <div class="empty-state">
                                    <i class="fas fa-clipboard-list empty-state-icon"></i>
                                    <p class="empty-state-text">Aucune règle d'annulation n'existe actuellement</p>
                                    <p class="empty-state-subtext">Utilisez le formulaire ci-dessous pour en créer une</p>
                                </div>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- Formulaire d'ajout si aucune règle n'existe -->
        <% if (regles == null || regles.isEmpty()) { %>
            <div class="card bg-white">
                <div class="header-gradient">
                    <h2 class="text-2xl font-bold flex items-center">
                        <i class="fas fa-plus-circle mr-3"></i>
                        Ajouter une Règle d'Annulation
                    </h2>
                </div>

                <!-- Formulaire -->
                <form action="${pageContext.request.contextPath}/regles-annulation/add" method="post" class="p-6">
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                        <!-- Heures après réservation -->
                        <div class="form-group">
                            <label class="form-label">
                                <i class="fas fa-hourglass-half text-red-500 mr-2"></i>
                                Heures après réservation
                            </label>
                            <input type="number" name="heuresApresReservation" class="form-input" placeholder="Ex: 24">
                            <p class="text-gray-500 text-sm mt-1">Nombre d'heures maximum après la réservation pour permettre l'annulation</p>
                        </div>

                        <!-- Active -->
                        <div class="form-group">
                            <label class="form-label">
                                <i class="fas fa-toggle-on text-red-500 mr-2"></i>
                                Statut de la règle
                            </label>
                            <select name="active" class="form-input">
                                <option value="true">Active</option>
                                <option value="false">Inactive</option>
                            </select>
                            <p class="text-gray-500 text-sm mt-1">Déterminez si cette règle doit être appliquée immédiatement</p>
                        </div>
                    </div>
                    <div class="mt-8 flex justify-end">
                        <button type="submit" class="btn-primary">
                            <i class="fas fa-plus mr-2"></i>Ajouter la règle
                        </button>
                    </div>
                </form>
            </div>
        <% } %>
    </div>
</body>
</html>
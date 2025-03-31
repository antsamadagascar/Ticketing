<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.Map" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestion des Règles de Réservation</title>
    <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
    <style>
        .page-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 2rem;
            margin-top: 50px;
        }
        
        .card {
            border-radius: 12px;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.05);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }
        
        .card:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 30px rgba(0, 0, 0, 0.1);
        }
        
        .header-gradient {
            background: linear-gradient(135deg, #3b82f6 0%, #1e40af 100%);
            color: white;
            border-radius: 12px 12px 0 0;
            padding: 1.5rem;
        }
        
        .btn-primary {
            background: linear-gradient(135deg, #3b82f6 0%, #1e40af 100%);
            color: white;
            padding: 0.75rem 1.5rem;
            border-radius: 8px;
            font-weight: 600;
            transition: all 0.3s ease;
            border: none;
            box-shadow: 0 4px 6px rgba(59, 130, 246, 0.25);
        }
        
        .btn-primary:hover {
            background: linear-gradient(135deg, #2563eb 0%, #1e3a8a 100%);
            box-shadow: 0 6px 8px rgba(59, 130, 246, 0.35);
            transform: translateY(-2px);
        }
        
        table {
            border-collapse: separate;
            border-spacing: 0;
        }
        
        table th {
            background-color: #f3f4f6;
            color: #4b5563;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            padding: 1rem 1.5rem;
            border-bottom: 1px solid #e5e7eb;
        }
        
        table td {
            padding: 1rem 1.5rem;
            border-bottom: 1px solid #f3f4f6;
        }
        
        .table-container {
            border-radius: 12px;
            overflow: hidden;
        }
        
        .status-badge {
            padding: 0.25rem 0.75rem;
            border-radius: 9999px;
            font-size: 0.875rem;
            font-weight: 500;
            display: inline-flex;
            align-items: center;
        }
        
        .status-active {
            background-color: #d1fae5;
            color: #065f46;
        }
        
        .status-inactive {
            background-color: #fee2e2;
            color: #b91c1c;
        }
        
        .alert {
            border-radius: 8px;
            padding: 1rem;
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            border-left: 4px solid;
        }
        
        .alert-success {
            background-color: #ecfdf5;
            border-left-color: #10b981;
        }
        
        .alert-error {
            background-color: #fef2f2;
            border-left-color: #ef4444;
        }
        
        .form-group {
            margin-bottom: 1.5rem;
        }
        
        .form-label {
            display: block;
            font-weight: 500;
            margin-bottom: 0.5rem;
            color: #374151;
        }
        
        .form-input {
            width: 100%;
            padding: 0.75rem 1rem;
            border: 1px solid #d1d5db;
            border-radius: 8px;
            transition: border-color 0.3s ease, box-shadow 0.3s ease;
            background-color: #f9fafb;
        }
        
        .form-input:focus {
            outline: none;
            border-color: #3b82f6;
            box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.2);
            background-color: white;
        }
        
        .icon-button {
            display: inline-flex;
            align-items: center;
            padding: 0.5rem 1rem;
            border-radius: 8px;
            font-weight: 500;
            transition: all 0.2s ease;
        }
        
        .icon-button-edit {
            color: #3b82f6;
            background-color: #eff6ff;
        }
        
        .icon-button-edit:hover {
            background-color: #dbeafe;
            color: #1d4ed8;
        }
    </style>
</head>
<body>
    <div class="page-container">
        <!-- Titre de la page avec gradient header -->
        <div class="header-gradient mb-8">
            <h2 class="text-3xl font-bold flex items-center">
                <i class="fas fa-calendar-check mr-3 text-2xl"></i>
                Gestion des Règles de Réservation
            </h2>
            <p class="text-blue-50 mt-2">Configuration des délais de réservation avant le vol</p>
        </div>

        <!-- Message de succès -->
        <% String successMessage = (String) request.getAttribute("successMessage"); %>
        <% if (successMessage != null) { %>
            <div class="alert alert-success">
                <i class="fas fa-check-circle text-green-500 text-xl mr-3"></i>
                <span><%= successMessage %></span>
            </div>
        <% } %>

        <!-- Tableau des règles -->
        <div class="card bg-white mb-10">
            <div class="p-5 border-b border-gray-200">
                <h3 class="text-xl font-semibold text-gray-800">Liste des règles existantes</h3>
                <p class="text-gray-500 text-sm mt-1">Consultez et modifiez les règles de réservation actuelles</p>
            </div>
            
            <div class="table-container">
                <table class="min-w-full">
                    <thead>
                        <tr>
                            <th class="text-left">Heures avant vol</th>
                            <th class="text-left">Statut</th>
                            <th class="text-left">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% 
                            java.util.List<models.RegleReservation> regles = (java.util.List<models.RegleReservation>) request.getAttribute("regles");
                            boolean hasRegle = regles != null && !regles.isEmpty();
                            
                            if (hasRegle) {
                                for (models.RegleReservation regle : regles) {
                        %>
                        <tr class="hover:bg-gray-50 transition duration-200">
                            <td class="text-gray-800 font-medium">
                                <div class="flex items-center">
                                    <i class="fas fa-clock text-blue-400 mr-2"></i>
                                    <%= regle.getHeuresAvantVol() %> heures
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
                                <a href="${pageContext.request.contextPath}/regles-reservation/edit?id=<%= regle.getId() %>" class="icon-button icon-button-edit">
                                    <i class="fas fa-edit mr-2"></i>Modifier
                                </a>
                            </td>
                        </tr>
                        <% } } else { %>
                        <tr>
                            <td colspan="3" class="text-center py-8 text-gray-500">
                                <i class="fas fa-info-circle text-blue-400 text-2xl mb-2"></i>
                                <p>Aucune règle de réservation n'existe actuellement.</p>
                                <p class="text-sm">Utilisez le formulaire ci-dessous pour en créer une.</p>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- Formulaire d'ajout si aucune règle n'existe -->
        <% if (!hasRegle) { %>
            <div class="card bg-white">
                <div class="header-gradient">
                    <h2 class="text-2xl font-bold flex items-center">
                        <i class="fas fa-plus-circle mr-3"></i>
                        Ajouter une Règle de Réservation
                    </h2>
                </div>

                <!-- Affichage des erreurs -->
                <% Map<String, String> errors = (Map<String, String>) request.getAttribute("errors"); %>
                <% if (errors != null && !errors.isEmpty()) { %>
                    <div class="alert alert-error m-6">
                        <i class="fas fa-exclamation-circle text-red-500 text-xl mr-3"></i>
                        <ul>
                            <% for (Map.Entry<String, String> entry : errors.entrySet()) { %>
                                <li><%= entry.getValue() %></li>
                            <% } %>
                        </ul>
                    </div>
                <% } %>

                <!-- Formulaire -->
                <form action="${pageContext.request.contextPath}/regles-reservation/add" method="post" class="p-6">
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                        <!-- Heures avant vol -->
                        <div class="form-group">
                            <label class="form-label">
                                <i class="fas fa-clock text-blue-500 mr-2"></i>
                                Heures avant vol
                            </label>
                            <input type="number" name="heuresAvantVol" class="form-input" placeholder="Ex: 24">
                            <p class="text-gray-500 text-sm mt-1">Nombre d'heures minimum avant le vol pour autoriser la réservation</p>
                        </div>

                        <!-- Active -->
                        <div class="form-group">
                            <label class="form-label">
                                <i class="fas fa-toggle-on text-blue-500 mr-2"></i>
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
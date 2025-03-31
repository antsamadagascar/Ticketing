<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestion des Promotions</title>

</head>
<body>
    <div class="container mx-auto">
        <!-- Titre de la page -->
        <h2 class="text-3xl font-bold text-gray-800 mb-6 flex items-center">
            <i class="fas fa-tags text-blue-500 mr-2"></i>
            Liste des Promotions
        </h2>

        <!-- Messages de succès et d'erreur -->
        <% if (request.getAttribute("successMessage") != null) { %>
            <div class="bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded-lg mb-6 flex items-center">
                <i class="fas fa-check-circle text-green-500 mr-2"></i>
                <span><%= request.getAttribute("successMessage") %></span>
            </div>
        <% } %>

        <% if (request.getAttribute("errorMessage") != null) { %>
            <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded-lg mb-6 flex items-center">
                <i class="fas fa-exclamation-circle text-red-500 mr-2"></i>
                <span><%= request.getAttribute("errorMessage") %></span>
            </div>
        <% } %>

        <!-- Formulaire d'ajout de promotion -->
        <div class="mb-8 bg-white p-6 rounded-xl shadow-lg">
            <h3 class="text-xl font-semibold text-gray-700 mb-4 flex items-center">
                <i class="fas fa-plus-circle text-blue-500 mr-2"></i>
                Ajouter une Promotion
            </h3>
            <form action="${pageContext.request.contextPath}/promotions/add" method="post">
                <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                    <!-- Vol -->
                    <div>
                        <label class="block text-gray-700 font-medium mb-2">Vol</label>
                        <select name="volId" class="w-full p-3 border rounded-lg focus:ring-2 focus:ring-blue-500 <%= request.getAttribute("volIdError") != null ? "border-red-500" : "" %>">
                            <% java.util.List<models.Vol> vols = (java.util.List<models.Vol>) request.getAttribute("vols");
                               Integer selectedVolId = (Integer) request.getAttribute("volId");
                               if (vols != null) {
                                   for (models.Vol vol : vols) { %>
                                       <option value="<%= vol.getId() %>" <%= selectedVolId != null && selectedVolId == vol.getId() ? "selected" : "" %>><%= vol.getNumeroVol() %></option>
                            <% } } %>
                        </select>
                        <% if (request.getAttribute("volIdError") != null) { %>
                            <p class="text-red-500 text-sm mt-1"><%= request.getAttribute("volIdError") %></p>
                        <% } %>
                    </div>

                    <!-- Type de siège -->
                    <div>
                        <label class="block text-gray-700 font-medium mb-2">Type Siège</label>
                        <select name="typeSiegeId" class="w-full p-3 border rounded-lg focus:ring-2 focus:ring-blue-500 <%= request.getAttribute("typeSiegeIdError") != null ? "border-red-500" : "" %>">
                            <% java.util.List<models.TypeSiege> typesSiege = (java.util.List<models.TypeSiege>) request.getAttribute("typesSiege");
                               Integer selectedTypeSiegeId = (Integer) request.getAttribute("typeSiegeId");
                               if (typesSiege != null) {
                                   for (models.TypeSiege type : typesSiege) { %>
                                       <option value="<%= type.getId() %>" <%= selectedTypeSiegeId != null && selectedTypeSiegeId == type.getId() ? "selected" : "" %>><%= type.getNom() %></option>
                            <% } } %>
                        </select>
                        <% if (request.getAttribute("typeSiegeIdError") != null) { %>
                            <p class="text-red-500 text-sm mt-1"><%= request.getAttribute("typeSiegeIdError") %></p>
                        <% } %>
                    </div>

                    <!-- Taux de promotion -->
                    <div>
                        <label class="block text-gray-700 font-medium mb-2">Taux Promotion (%)</label>
                        <input type="number" step="0.01" name="tauxPromotion" value="<%= request.getAttribute("tauxPromotion") != null ? request.getAttribute("tauxPromotion") : "" %>"
                               class="w-full p-3 border rounded-lg focus:ring-2 focus:ring-blue-500 <%= request.getAttribute("tauxPromotionError") != null ? "border-red-500" : "" %>" min="0" max="100">
                        <% if (request.getAttribute("tauxPromotionError") != null) { %>
                            <p class="text-red-500 text-sm mt-1"><%= request.getAttribute("tauxPromotionError") %></p>
                        <% } %>
                    </div>

                    <!-- Date de début -->
                    <div>
                        <label class="block text-gray-700 font-medium mb-2">Date Début</label>
                        <input type="datetime-local" name="dateDebut" value="<%= request.getAttribute("dateDebut") != null ? request.getAttribute("dateDebut") : "" %>"
                               class="w-full p-3 border rounded-lg focus:ring-2 focus:ring-blue-500 <%= request.getAttribute("dateDebutError") != null ? "border-red-500" : "" %>">
                        <% if (request.getAttribute("dateDebutError") != null) { %>
                            <p class="text-red-500 text-sm mt-1"><%= request.getAttribute("dateDebutError") %></p>
                        <% } %>
                    </div>

                    <!-- Date de fin -->
                    <div>
                        <label class="block text-gray-700 font-medium mb-2">Date Fin</label>
                        <input type="datetime-local" name="dateFin" value="<%= request.getAttribute("dateFin") != null ? request.getAttribute("dateFin") : "" %>"
                               class="w-full p-3 border rounded-lg focus:ring-2 focus:ring-blue-500 <%= request.getAttribute("dateFinError") != null ? "border-red-500" : "" %>">
                        <% if (request.getAttribute("dateFinError") != null) { %>
                            <p class="text-red-500 text-sm mt-1"><%= request.getAttribute("dateFinError") %></p>
                        <% } %>
                    </div>
                </div>
                <button type="submit" class="mt-6 px-6 py-3 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition duration-300">
                    <i class="fas fa-plus mr-2"></i>Ajouter
                </button>
            </form>
        </div>

        <!-- Tableau des promotions -->
        <div class="bg-white shadow-lg rounded-xl overflow-hidden">
            <table class="min-w-full">
                <thead class="bg-gray-100">
                    <tr>
                        <th class="px-6 py-4 text-left text-sm font-semibold text-gray-700 uppercase">ID</th>
                        <th class="px-6 py-4 text-left text-sm font-semibold text-gray-700 uppercase">Numéro Vol</th>
                        <th class="px-6 py-4 text-left text-sm font-semibold text-gray-700 uppercase">Type Siège</th>
                        <th class="px-6 py-4 text-left text-sm font-semibold text-gray-700 uppercase">Taux Promotion</th>
                        <th class="px-6 py-4 text-left text-sm font-semibold text-gray-700 uppercase">Date Début</th>
                        <th class="px-6 py-4 text-left text-sm font-semibold text-gray-700 uppercase">Date Fin</th>
                        <th class="px-6 py-4 text-left text-sm font-semibold text-gray-700 uppercase">Actions</th>
                    </tr>
                </thead>
                <tbody class="divide-y divide-gray-200">
                    <% java.util.List<models.PromotionVol> promotions = (java.util.List<models.PromotionVol>) request.getAttribute("promotions");
                        if (promotions != null) {
                            for (models.PromotionVol promo : promotions) { %>
                                <tr class="hover:bg-gray-50 transition duration-200">
                                    <td class="px-6 py-4 text-sm text-gray-900"><%= promo.getId() %></td>
                                    <td class="px-6 py-4 text-sm text-gray-900"><%= promo.getVol().getNumeroVol() %></td>
                                    <td class="px-6 py-4 text-sm text-gray-900"><%= promo.getTypeSiege().getNom() %></td>
                                    <td class="px-6 py-4 text-sm text-gray-900"><%= promo.getTauxPromotion() %> %</td>
                                    <td class="px-6 py-4 text-sm text-gray-900"><%= promo.getDateDebut() %></td>
                                    <td class="px-6 py-4 text-sm text-gray-900"><%= promo.getDateFin() %></td>
                                    <td class="px-6 py-4 text-sm font-medium">
                                        <a href="${pageContext.request.contextPath}/promotions/edit?id=<%= promo.getId() %>" class="text-blue-600 hover:text-blue-900">
                                            <i class="fas fa-edit mr-2"></i>Configurer
                                        </a>
                                    </td>
                                </tr>
                    <% } } %>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>
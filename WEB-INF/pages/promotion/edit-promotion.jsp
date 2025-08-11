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
        <h2 class="text-2xl font-bold text-gray-800 mb-6">Liste des Promotions</h2>

        <div class="mb-6">
            <h3 class="text-xl font-semibold text-gray-700">Modifier une Promotion</h3>
            <form action="${pageContext.request.contextPath}/promotions/update" method="post" class="bg-white p-4 shadow-md rounded-lg">
                <input type="hidden" name="id" value="<%= request.getAttribute("promotion") != null ? ((models.PromotionVol) request.getAttribute("promotion")).getId() : "" %>">
                <div class="grid grid-cols-2 gap-4">
                    <div>
                        <label class="block text-gray-700">Vol</label>
                        <select name="volId" class="w-full p-2 border rounded" >
                            <% models.PromotionVol promotion = (models.PromotionVol) request.getAttribute("promotion");
                               java.util.List<models.Vol> vols = (java.util.List<models.Vol>) request.getAttribute("vols");
                               if (vols != null) {
                                   for (models.Vol vol : vols) {
                                       boolean selected = promotion != null && promotion.getVol().getId() == vol.getId(); %>
                                       <option value="<%= vol.getId() %>" <%= selected ? "selected" : "" %>><%= vol.getNumeroVol() %></option>
                            <% } } %>
                        </select>
                    </div>
                    <div>
                        <label class="block text-gray-700">Type Siège</label>
                        <select name="typeSiegeId" class="w-full p-2 border rounded" >
                            <% java.util.List<models.TypeSiege> typesSiege = (java.util.List<models.TypeSiege>) request.getAttribute("typesSiege");
                               if (typesSiege != null) {
                                   for (models.TypeSiege typeSiege : typesSiege) {
                                       boolean selected = promotion != null && promotion.getTypeSiege().getId() == typeSiege.getId(); %>
                                       <option value="<%= typeSiege.getId() %>" <%= selected ? "selected" : "" %>><%= typeSiege.getNom() %></option>
                            <% } } %>
                        </select>
                    </div>
                    <div>
                        <label class="block text-gray-700">Taux Promotion</label>
                        <input type="number" step="0.01" name="tauxPromotion" class="w-full p-2 border rounded" value="<%= promotion != null ? promotion.getTauxPromotion() : "" %>" >
                    </div>
                    <div>
                        <label class="block text-gray-700">Date Début</label>
                        <input type="datetime-local" name="dateDebut" class="w-full p-2 border rounded" value="<%= promotion != null ? promotion.getDateDebut().toString().replace(' ', 'T') : "" %>" >
                    </div>
                    <div>
                        <label class="block text-gray-700">Date Fin</label>
                        <input type="datetime-local" name="dateFin" class="w-full p-2 border rounded" value="<%= promotion != null ? promotion.getDateFin().toString().replace(' ', 'T') : "" %>" >
                    </div>
                    <div class="col-span-2">
                        <label class="block text-gray-700 font-medium mb-2">Promotion Active</label>
                        <input type="checkbox" name="estActive" value="true"
                            <%= promotion != null && promotion.isEstActive() ? "checked" : "" %>>
                        <span class="ml-2 text-sm text-gray-600">Activer cette promotion</span>
                    </div>
                    <div>
                        <label class="block text-gray-700">Nombres siege Promotion</label>
                        <input type="number" step="0.01" name="nbrSiegePromo" class="w-full p-2 border rounded" value="<%= promotion != null ? promotion.getNbrSiegePromo() : "" %>" >
                    </div>
                </div>
                <button type="submit" class="mt-4 px-4 py-2 bg-blue-600 text-white rounded">Mettre à jour</button>
            </form>
        </div>
    </div>
</body>
</html>

<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestion des Vols</title>
</head>
<style>
    
</style>
<h2 class="text-2xl font-bold text-gray-800 mt-8 mb-6">Modifier un Vol</h2>
<form action="${pageContext.request.contextPath}/vols/update" method="post" class="bg-white shadow-md rounded-lg p-6">
    <input type="hidden" name="id" value="<%= ((models.Vol) request.getAttribute("vol")).getId() %>">

    <!-- Grille pour organiser les champs du formulaire -->
    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
        <!-- Numéro Vol -->
        <div>
            <label class="block text-sm font-medium text-gray-700">Numéro Vol:</label>
            <input type="text" name="numeroVol"  
                   class="mt-1 block w-full rounded-md border-gray-300 shadow-sm p-2 focus:ring-blue-500 focus:border-blue-500"
                   value="<%= ((models.Vol) request.getAttribute("vol")).getNumeroVol() %>">
        </div>

        <!-- Ville Départ -->
        <div>
            <label class="block text-sm font-medium text-gray-700">Ville Départ:</label>
            <select name="villeDepartId"  
                    class="mt-1 block w-full rounded-md border-gray-300 shadow-sm p-2 focus:ring-blue-500 focus:border-blue-500">
                <%
                    List<models.Ville> villes = (List<models.Ville>) request.getAttribute("villes");
                    models.Vol vol = (models.Vol) request.getAttribute("vol");
                    if (villes != null) {
                        for (models.Ville ville : villes) {
                %>
                    <option value="<%= ville.getId() %>" <%= (ville.getId() == vol.getVilleDepart().getId()) ? "selected" : "" %>>
                        <%= ville.getNom() %>
                    </option>
                <%
                        }
                    }
                %>
            </select>
        </div>

        <!-- Ville Arrivée -->
        <div>
            <label class="block text-sm font-medium text-gray-700">Ville Arrivée:</label>
            <select name="villeArriveeId"  
                    class="mt-1 block w-full rounded-md border-gray-300 shadow-sm p-2 focus:ring-blue-500 focus:border-blue-500">
                <%
                    if (villes != null) {
                        for (models.Ville ville : villes) {
                %>
                    <option value="<%= ville.getId() %>" <%= (ville.getId() == vol.getVilleArrivee().getId()) ? "selected" : "" %>>
                        <%= ville.getNom() %>
                    </option>
                <%
                        }
                    }
                %>
            </select>
        </div>

        <!-- Date Départ -->
        <div>
            <label class="block text-sm font-medium text-gray-700">Date Départ:</label>
            <input type="datetime-local" name="dateDepart"  
                   class="mt-1 block w-full rounded-md border-gray-300 shadow-sm p-2 focus:ring-blue-500 focus:border-blue-500"
                   value="<%= new java.text.SimpleDateFormat("yyyy-MM-dd'T'HH:mm").format(vol.getDateDepart()) %>">
        </div>

        <!-- Date Arrivée -->
        <div>
            <label class="block text-sm font-medium text-gray-700">Date Arrivée:</label>
            <input type="datetime-local" name="dateArrivee"  
                   class="mt-1 block w-full rounded-md border-gray-300 shadow-sm p-2 focus:ring-blue-500 focus:border-blue-500"
                   value="<%= new java.text.SimpleDateFormat("yyyy-MM-dd'T'HH:mm").format(vol.getDateArrivee()) %>">
        </div>

        <!-- Avion -->
        <div>
            <label class="block text-sm font-medium text-gray-700">Avion:</label>
            <select name="avionId"  
                    class="mt-1 block w-full rounded-md border-gray-300 shadow-sm p-2 focus:ring-blue-500 focus:border-blue-500">
                <%
                    List<models.Avion> avions = (List<models.Avion>) request.getAttribute("avions");
                    if (avions != null) {
                        for (models.Avion avion : avions) {
                %>
                    <option value="<%= avion.getId() %>" <%= (avion.getId() == vol.getAvion().getId()) ? "selected" : "" %>>
                        <%= avion.getModele() %>
                    </option>
                <%
                        }
                    }
                %>
            </select>
        </div>

        <!-- Statut -->
        <div>
            <label class="block text-sm font-medium text-gray-700">Statut:</label>
            <select name="statut"  
                    class="mt-1 block w-full rounded-md border-gray-300 shadow-sm p-2 focus:ring-blue-500 focus:border-blue-500">
                <option value="0" <%= (vol.getStatut() == 0) ? "selected" : "" %>>Programmé</option>
                <option value="1" <%= (vol.getStatut() == 1) ? "selected" : "" %>>Terminé</option>
                <option value="-1" <%= (vol.getStatut() == -1) ? "selected" : "" %>>Annulé</option>
            </select>
        </div>
        
    </div>

    <!-- Bouton de mise à jour -->
    <div class="mt-6">
        <button type="submit" class="w-full bg-blue-600 text-white rounded-md py-2 hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2">
            Mettre à jour
        </button>
    </div>
</form>
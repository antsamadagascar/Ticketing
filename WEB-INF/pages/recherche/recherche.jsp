<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="models.Ville" %>
<%@ page import="models.TypeSiege" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Recherche de Vols</title>
</head>
<body >
    <div class="container mx-auto max-w-4xl">
        <h1 class="text-3xl font-bold text-gray-800 mb-6">Recherche de Vols</h1>
        
        <!-- Formulaire de recherche -->
        <form action="${pageContext.request.contextPath}/recherche/resultats" method="post" class="bg-white p-6 shadow-md rounded-lg">
            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div>
                    <label for="villeDepart" class="block text-gray-700 font-medium mb-1">Ville de départ</label>
                    <select class="w-full p-2 border border-gray-300 rounded focus:outline-none focus:ring-2 focus:ring-blue-500" id="villeDepart" name="villeDepartId">
                        <% for (Ville ville : (List<Ville>) request.getAttribute("villes")) { %>
                            <option value="<%= ville.getId() %>"><%= ville.getNom() %></option>
                        <% } %>
                    </select>
                </div>
                
                <div>
                    <label for="villeArrivee" class="block text-gray-700 font-medium mb-1">Ville d'arrivée</label>
                    <select class="w-full p-2 border border-gray-300 rounded focus:outline-none focus:ring-2 focus:ring-blue-500" id="villeArrivee" name="villeArriveeId">
                        <% for (Ville ville : (List<Ville>) request.getAttribute("villes")) { %>
                            <option value="<%= ville.getId() %>"><%= ville.getNom() %></option>
                        <% } %>
                    </select>
                </div>
                
                <div>
                    <label for="dateDepart" class="block text-gray-700 font-medium mb-1">Date de départ</label>
                    <input type="datetime-local" class="w-full p-2 border border-gray-300 rounded focus:outline-none focus:ring-2 focus:ring-blue-500" id="dateDepart" name="dateDepart">
                </div>
                
                <div>
                    <label for="typeSiege" class="block text-gray-700 font-medium mb-1">Type de siège</label>
                    <select class="w-full p-2 border border-gray-300 rounded focus:outline-none focus:ring-2 focus:ring-blue-500" id="typeSiege" name="typeSiegeId">
                        <% for (TypeSiege type : (List<TypeSiege>) request.getAttribute("typesSiege")) { %>
                            <option value="<%= type.getId() %>"><%= type.getNom() %></option>
                        <% } %>
                    </select>
                </div>
                
                <div>
                    <label for="prixMin" class="block text-gray-700 font-medium mb-1">Prix minimum</label>
                    <input type="number" class="w-full p-2 border border-gray-300 rounded focus:outline-none focus:ring-2 focus:ring-blue-500" id="prixMin" name="prixMin" step="0.01" min="0">
                </div>
                
                <div>
                    <label for="prixMax" class="block text-gray-700 font-medium mb-1">Prix maximum</label>
                    <input type="number" class="w-full p-2 border border-gray-300 rounded focus:outline-none focus:ring-2 focus:ring-blue-500" id="prixMax" name="prixMax" step="0.01" min="0">
                </div>
                
                <div class="md:col-span-2">
                    <label for="nombrePassagers" class="block text-gray-700 font-medium mb-1">Nombre de passagers</label>
                    <input type="number" class="w-full p-2 border border-gray-300 rounded focus:outline-none focus:ring-2 focus:ring-blue-500" id="nombrePassagers" name="nombrePassagers" min="1">
                </div>
            </div>
            
            <div class="mt-6">
                <button type="submit" class="px-6 py-2 bg-blue-600 text-white font-medium rounded hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-500 transition duration-150">Rechercher</button>
            </div>
        </form>
    </div>
</body>
</html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="models.VolMulticritereResult" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Résultats de la Recherche</title>
</head>
<body >
    <div class="container mx-auto max-w-6xl">
        <h1 class="text-3xl font-bold text-gray-800 mb-6">Résultats de la Recherche</h1>
        
        <% if (request.getAttribute("vols") != null && !((List<VolMulticritereResult>) request.getAttribute("vols")).isEmpty()) { %>
            <div class="bg-white shadow-md rounded-lg overflow-hidden">
                <div class="overflow-x-auto">
                    <table class="min-w-full">
                        <thead class="bg-gray-200">
                            <tr>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-600 uppercase tracking-wider">Numéro de vol</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-600 uppercase tracking-wider">Ville de départ</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-600 uppercase tracking-wider">Ville d'arrivée</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-600 uppercase tracking-wider">Date de départ</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-600 uppercase tracking-wider">Date d'arrivée</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-600 uppercase tracking-wider">Type de siège</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-600 uppercase tracking-wider">Prix</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-600 uppercase tracking-wider">Promotion</th>
                            </tr>
                        </thead>
                        <tbody class="bg-white divide-y divide-gray-200">
                            <% for (VolMulticritereResult vol : (List<VolMulticritereResult>) request.getAttribute("vols")) { %>
                                <tr class="hover:bg-gray-50">
                                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900"><%= vol.getNumeroVol() %></td>
                                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900"><%= vol.getVilleDepart().getNom() %></td>
                                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900"><%= vol.getVilleArrivee().getNom() %></td>
                                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900"><%= vol.getDateDepart() %></td>
                                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900"><%= vol.getDateArrivee() %></td>
                                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900"><%= vol.getTypeSiege().getNom() %></td>
                                    <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-900"><%= vol.getPrixMinimum() %> - <%= vol.getPrixMaximum() %></td>
                                    <td class="px-6 py-4 whitespace-nowrap">
                                        <% if (vol.isEstEnPromotion()) { %>
                                            <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-green-100 text-green-800">Oui</span>
                                        <% } else { %>
                                            <span class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-gray-100 text-gray-800">Non</span>
                                        <% } %>
                                    </td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        <% } else { %>
            <div class="bg-white p-6 shadow-md rounded-lg text-center">
                <p class="text-lg text-gray-700">Aucun vol trouvé pour les critères spécifiés.</p>
                <a href="javascript:history.back()" class="inline-block mt-4 px-4 py-2 bg-blue-600 text-white font-medium rounded hover:bg-blue-700">Retour à la recherche</a>
            </div>
        <% } %>
    </div>
</body>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Rechercher un Vol - AirTicket</title>
</head>
<body>
    <!-- Formulaire de recherche -->
    <div class="bg-white rounded-lg shadow p-6 mb-8">
        <h2 class="text-2xl font-bold text-blue-600 mb-6">Rechercher un Vol</h2>
        <form action="${pageContext.request.contextPath}/search" method="GET" class="grid grid-cols-1 md:grid-cols-4 gap-4">
            <div>
                <label class="block text-sm font-medium text-gray-700">Départ</label>
                <select name="departure"  class="mt-1 block w-full rounded-md border-gray-300 shadow-sm p-2">
                    <option value="">Sélectionnez une ville</option>
                    <option value="Paris">Paris</option>
                    <option value="Lyon">Lyon</option>
                    <option value="Marseille">Marseille</option>
                </select>
            </div>
            <div>
                <label class="block text-sm font-medium text-gray-700">Destination</label>
                <select name="destination"  class="mt-1 block w-full rounded-md border-gray-300 shadow-sm p-2">
                    <option value="">Sélectionnez une ville</option>
                    <option value="New York">New York</option>
                    <option value="Tokyo">Tokyo</option>
                    <option value="Londres">Londres</option>
                </select>
            </div>
            <div>
                <label class="block text-sm font-medium text-gray-700">Date de départ</label>
                <input type="date" name="departureDate"  class="mt-1 block w-full rounded-md border-gray-300 shadow-sm p-2">
            </div>
            <div class="flex items-end">
                <button type="submit" class="w-full bg-blue-600 text-white rounded-md py-2 hover:bg-blue-700">
                    Rechercher
                </button>
            </div>
        </form>
    </div>

    <!-- Résultats de recherche -->
    <div class="bg-white rounded-lg shadow p-6">
        <h3 class="text-xl font-bold text-gray-900 mb-4">Résultats de la Recherche</h3>
        <div class="space-y-4">
            <!-- Exemple de résultat -->
            <div class="p-4 border border-gray-200 rounded-lg">
                <div class="flex justify-between items-center">
                    <div>
                        <h4 class="text-lg font-semibold text-gray-900">Paris → New York</h4>
                        <p class="text-sm text-gray-600">Date : 2023-10-15</p>
                    </div>
                    <div>
                        <p class="text-lg font-bold text-blue-600">€450</p>
                        <a href="#" class="text-sm text-blue-600 hover:underline">Réserver</a>
                    </div>
                </div>
            </div>

            <!-- Autre exemple de résultat -->
            <div class="p-4 border border-gray-200 rounded-lg">
                <div class="flex justify-between items-center">
                    <div>
                        <h4 class="text-lg font-semibold text-gray-900">Lyon → Tokyo</h4>
                        <p class="text-sm text-gray-600">Date : 2023-10-20</p>
                    </div>
                    <div>
                        <p class="text-lg font-bold text-blue-600">€600</p>
                        <a href="#" class="text-sm text-blue-600 hover:underline">Réserver</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
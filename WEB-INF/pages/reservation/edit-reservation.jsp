<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Modifier Règle de Réservation</title>
</head>
<body>
    <div class="container mx-auto">
        <h2 class="text-2xl font-bold text-gray-800 mb-6">Modifier la Règle de Réservation</h2>

        <form action="${pageContext.request.contextPath}/regles-reservation/update" method="post" class="bg-white p-4 shadow-md rounded-lg">
            <input type="hidden" name="id" value="<%= request.getAttribute("regle") != null ? ((models.RegleReservation) request.getAttribute("regle")).getId() : "" %>">
            
            <div>
                <label class="block text-gray-700">Heures avant vol</label>
                <input type="number" name="heuresAvantVol" class="w-full p-2 border rounded" 
                    value="<%= request.getAttribute("regle") != null ? ((models.RegleReservation) request.getAttribute("regle")).getHeuresAvantVol() : "" %>">
            </div>

            <div class="mt-4">
                <label class="block text-gray-700">Active</label>
                <select name="active" class="w-full p-2 border rounded">
                    <option value="true" <%= request.getAttribute("regle") != null && ((models.RegleReservation) request.getAttribute("regle")).isActive() ? "selected" : "" %>>Oui</option>
                    <option value="false" <%= request.getAttribute("regle") != null && !((models.RegleReservation) request.getAttribute("regle")).isActive() ? "selected" : "" %>>Non</option>
                </select>
            </div>

            <button type="submit" class="mt-4 px-4 py-2 bg-blue-600 text-white rounded">Mettre à jour</button>
        </form>
    </div>
</body>
</html>

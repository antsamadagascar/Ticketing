<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr">
<head><title>Erreur</title></head>
<body>
    <h2>Une erreur est survenue</h2>
    <p><%= request.getAttribute("error") != null ? request.getAttribute("error") : "Erreur inconnue." %></p>
    <a href="<%= request.getContextPath() %>/mes-reservation">Retour à mes réservations</a>
</body>
</html>

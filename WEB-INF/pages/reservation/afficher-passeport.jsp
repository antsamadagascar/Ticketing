<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="models.Passager" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Passeport - <%= request.getAttribute("fileName") %></title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/reservation/passeport.css" >
</head>
<body>
    <div class="container">
        <div class="header">
            <h1><i class="fas fa-passport"></i> Passeport</h1>
        </div>

        <%
            String messageError = (String) request.getAttribute("messageError");
            if (messageError != null) {
        %>
            <div class="error-message">
                <i class="fas fa-exclamation-triangle"></i>
                <h3>Erreur</h3>
                <p><%= messageError %></p>
            </div>
        <% } else { %>

        <%
            String fileName = (String) request.getAttribute("fileName");
            String contentType = (String) request.getAttribute("contentType");
            Passager passager = (Passager) request.getAttribute("passager");
            byte[] fileData = (byte[]) request.getAttribute("fileData");
            
            if (fileName != null && passager != null) {
        %>
        
        <div class="file-info">
            <div class="info-grid">
                <div class="info-item">
                    <i class="fas fa-file"></i>
                    <div>
                        <strong>Nom du fichier:</strong> <%= fileName %>
                    </div>
                </div>
                <div class="info-item">
                    <i class="fas fa-user"></i>
                    <div>
                        <strong>Passager:</strong> <%= passager.getPrenom() %> <%= passager.getNom() %>
                    </div>
                </div>
                <div class="info-item">
                    <i class="fas fa-birthday-cake"></i>
                    <div>
                        <strong>Date de naissance:</strong> <%= passager.getDateNaissance() %>
                    </div>
                </div>
                <div class="info-item">
                    <i class="fas fa-info-circle"></i>
                    <div>
                        <strong>Type:</strong> <%= contentType %>
                    </div>
                </div>
            </div>
        </div>

        <div class="file-viewer">
            <% if (contentType.startsWith("image/")) { %>
                <div class="file-content">
                    <%
                        String base64Image = java.util.Base64.getEncoder().encodeToString(fileData);
                    %>
                    <img src="data:<%= contentType %>;base64,<%= base64Image %>" alt="Passeport de <%= passager.getPrenom() %> <%= passager.getNom() %>">
                </div>
            <% } else if (contentType.equals("application/pdf")) { %>
                <div class="file-content">
                    <%
                        String base64Pdf = java.util.Base64.getEncoder().encodeToString(fileData);
                    %>
                    <iframe src="data:application/pdf;base64,<%= base64Pdf %>" type="application/pdf">
                        <p>Votre navigateur ne supporte pas l'affichage des PDF. 
                           <a href="data:application/pdf;base64,<%= base64Pdf %>" download="<%= fileName %>">
                               Téléchargez le fichier
                           </a>
                        </p>
                    </iframe>
                </div>
            <% } else { %>
                <div class="file-not-supported">
                    <i class="fas fa-file-alt"></i>
                    <h3>Aperçu non disponible</h3>
                    <p>Ce type de fichier ne peut pas être affiché directement dans le navigateur.</p>
                    <p>Utilisez le bouton de téléchargement ci-dessous pour ouvrir le fichier.</p>
                </div>
            <% } %>
        </div>

        <div class="download-section">
            <%
                String base64File = java.util.Base64.getEncoder().encodeToString(fileData);
            %>
            <a href="data:<%= contentType %>;base64,<%= base64File %>" 
               download="<%= fileName %>" 
               class="download-btn">
                <i class="fas fa-download"></i> Télécharger
            </a>
            
            <a href="${pageContext.request.contextPath}/mes-reservation" 
                class="back-btn">
                 <i class="fas fa-arrow-left"></i> Retour
             </a>
        </div>

        <% } %>
        <% } %>
    </div>

    <script>
        // Fonction pour revenir en arrière
        function goBack() {
            if (document.referrer) {
                history.back();
            } else {
                window.location.href = '/Ticketing/mes-reservation';
            }
        }
        
        // Gestion des erreurs d'image
        document.addEventListener('DOMContentLoaded', function() {
            const images = document.querySelectorAll('img');
            images.forEach(img => {
                img.onerror = function() {
                    this.style.display = 'none';
                    const errorDiv = document.createElement('div');
                    errorDiv.className = 'file-not-supported';
                    errorDiv.innerHTML = `
                        <i class="fas fa-exclamation-triangle"></i>
                        <h3>Erreur d'affichage</h3>
                        <p>L'image n'a pas pu être chargée. Le fichier pourrait être corrompu.</p>
                    `;
                    this.parentNode.appendChild(errorDiv);
                };
            });
        });
    </script>
</body>
</html>
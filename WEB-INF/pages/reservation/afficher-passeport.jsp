<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="models.Passager" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Passeport - <%= request.getAttribute("fileName") %></title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
  
      .container {
            max-width: 900px;
            margin: 0 auto;
            background: white;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
            overflow: hidden;
        }
        
        .header {
            background: linear-gradient(45deg, #2c3e50, #34495e);
            color: white;
            padding: 25px;
            text-align: center;
        }
        
        .header h1 {
            margin: 0;
            font-size: 2em;
            font-weight: 300;
        }
        
        .file-info {
            background: #f8f9fa;
            padding: 20px;
            border-bottom: 1px solid #e9ecef;
        }
        
        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
        }
        
        .info-item {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 10px;
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        
        .info-item i {
            color: #667eea;
            width: 20px;
        }
        
        .file-viewer {
            padding: 20px;
            text-align: center;
        }
        
        .file-content {
            max-width: 100%;
            margin: 0 auto;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        }
        
        .file-content img {
            max-width: 100%;
            height: auto;
            border-radius: 10px;
        }
        
        .file-content iframe {
            width: 100%;
            height: 600px;
            border: none;
            border-radius: 10px;
        }
        
        .download-section {
            background: #f8f9fa;
            padding: 20px;
            text-align: center;
            border-top: 1px solid #e9ecef;
        }
        
        .download-btn {
            background: linear-gradient(45deg, #28a745, #20c997);
            color: white;
            padding: 12px 25px;
            border: none;
            border-radius: 25px;
            cursor: pointer;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 10px;
            font-weight: 600;
            font-size: 1.1em;
            transition: all 0.3s ease;
            margin: 0 10px;
        }
        
        .download-btn:hover {
            background: linear-gradient(45deg, #218838, #1ea080);
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.2);
            text-decoration: none;
            color: white;
        }
        
        .back-btn {
            background: linear-gradient(45deg, #6c757d, #495057);
            color: white;
            padding: 12px 25px;
            border: none;
            border-radius: 25px;
            cursor: pointer;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 10px;
            font-weight: 600;
            font-size: 1.1em;
            transition: all 0.3s ease;
            margin: 0 10px;
        }
        
        .back-btn:hover {
            background: linear-gradient(45deg, #5a6268, #343a40);
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.2);
            text-decoration: none;
            color: white;
        }
        
        .error-message {
            background: #f8d7da;
            border: 1px solid #f5c6cb;
            color: #721c24;
            padding: 20px;
            margin: 20px;
            border-radius: 8px;
            text-align: center;
        }
        
        .error-message i {
            font-size: 3em;
            margin-bottom: 15px;
            display: block;
        }
        
        .file-not-supported {
            background: #fff3cd;
            border: 1px solid #ffeaa7;
            color: #856404;
            padding: 30px;
            text-align: center;
            border-radius: 10px;
        }
        
        .file-not-supported i {
            font-size: 4em;
            margin-bottom: 20px;
            display: block;
        }
        
        @media (max-width: 768px) {
            .container {
                margin: 10px;
                border-radius: 10px;
            }
            
            .info-grid {
                grid-template-columns: 1fr;
            }
            
            .download-btn, .back-btn {
                display: block;
                margin: 10px 0;
                width: 200px;
                margin-left: auto;
                margin-right: auto;
            }
        }
    </style>
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
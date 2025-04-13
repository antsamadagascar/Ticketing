<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="models.Vol" %>
<%@ page import="models.SiegeVol" %>
<%@ page import="models.Reservation" %>
<!DOCTYPE html>
<html>
<head>
    <title>Réserver un vol</title>
    <style>
        /* Variables pour les couleurs et les dimensions */
        /*
:root {
  --primary-color: #2c3e50;
  --secondary-color: #3498db;
  --accent-color: #e74c3c;
  --light-bg: #ecf0f1;
  --dark-text: #2c3e50;
  --light-text: #ffffff;
  --border-radius: 6px;
  --box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
  --transition: all 0.3s ease;
}
*/
/* Reset et styles généraux */
.success {
  background-color: rgba(46, 204, 113, 0.2);
  border-left: 4px solid var(--success);
  color: #27ae60;
}
        

.error {
  background-color: rgba(231, 76, 60, 0.2);
  border-left: 4px solid var(--danger);
  color: #c0392b;
}
        

* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
  font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
}


/* En-tête */
h2 {
  color: var(--primary-color);
  margin-bottom: 30px;
  text-align: center;
  font-size: 2rem;
  font-weight: 600;
  padding-bottom: 15px;
  border-bottom: 2px solid var(--secondary-color);
}

/* Conteneur principal */
form {
  max-width: 800px;
  margin: 0 auto;
  background-color: white;
  padding: 30px;
  border-radius: var(--border-radius);
  box-shadow: var(--box-shadow);
}

/* Groupes de formulaire */
.form-group {
  margin-bottom: 25px;
}

label {
  display: block;
  margin-bottom: 8px;
  font-weight: 600;
  color: var(--primary-color);
}

select, input {
  width: 100%;
  padding: 12px 15px;
  border: 1px solid #ddd;
  border-radius: var(--border-radius);
  background-color: #f9f9f9;
  color: var(--dark-text);
  font-size: 1rem;
  transition: var(--transition);
}

select:focus, input:focus {
  outline: none;
  border-color: var(--secondary-color);
  box-shadow: 0 0 0 2px rgba(52, 152, 219, 0.2);
}

/* Bouton */
button {
  display: block;
  width: 100%;
  padding: 14px;
  margin-top: 30px;
  background-color: var(--secondary-color);
  color: var(--light-text);
  border: none;
  border-radius: var(--border-radius);
  font-size: 1.1rem;
  cursor: pointer;
  transition: var(--transition);
}

button:hover {
  background-color: #2980b9;
  transform: translateY(-2px);
}

/* Zone de débogage */
#debug {
  display: none;
  margin-top: 30px;
  padding: 15px;
  background-color: #f8f9fa;
  border: 1px solid #ddd;
  border-radius: var(--border-radius);
  font-family: monospace;
  white-space: pre-wrap;
  overflow: auto;
  max-height: 300px;
}

/* Style pour l'input de fichier (passeport) */
input[type="file"] {
  padding: 10px;
  margin-bottom: 20px;
  border: 1px dashed #ddd;
  background-color: #f9f9f9;
}

/* Responsive design */
@media (max-width: 768px) {
  form {
    padding: 20px;
  }
  
  button {
    padding: 12px;
  }
}

/* Animations */
@keyframes fadeIn {
  from { opacity: 0; transform: translateY(10px); }
  to { opacity: 1; transform: translateY(0); }
}

form {
  animation: fadeIn 0.5s ease;
}

/* Style pour le conteneur de l'upload de passeport */
.file-upload {
  position: relative;
  margin-bottom: 25px;
}

.file-upload label {
  display: block;
  margin-bottom: 8px;
}

/* Indicateur de chargement */
.loading {
  opacity: 0.7;
  pointer-events: none;
}

/* Message d'erreur */
.error-message {
  color: var(--accent-color);
  font-size: 0.9rem;
  margin-top: 5px;
}

/* Message de succès */
.success-message {
  color: #27ae60;
  font-size: 0.9rem;
  margin-top: 5px;
}
    </style>
    <script>
        function chargerSieges() {
            let volId = document.getElementById("volSelect").value;
            if (volId) {
                $("#siegeSelect").empty().append(new Option("Chargement des sièges...", ""));
                
                $.ajax({
                    url: "${pageContext.request.contextPath}/sieges-disponibles",
                    type: "GET",
                    data: { volId: volId },
                    dataType: "text", 
                    success: function(responseText) {
                        $("#siegeSelect").empty();
                        
                        try {
                            let jsonData = extractJsonFromHtml(responseText);
                            
                            if (jsonData && jsonData.length > 0) {
                                $("#siegeSelect").append(new Option("Sélectionnez un siège", ""));
                                jsonData.forEach(function(siege) {
                                    $("#siegeSelect").append(new Option(siege.numero + " - " + siege.type + " (€" + siege.prix + ")", siege.id));
                                });
                            } else {
                                $("#siegeSelect").append(new Option("Aucun siège disponible", ""));
                            }
                        } catch (e) {
                            $("#siegeSelect").append(new Option("Erreur de format de données", ""));
                            console.error("Erreur lors de l'analyse des données:", e);
                            $("#debug").show().html("<strong>Erreur:</strong> " + e.message + "<br><strong>Réponse:</strong><br>" + 
                                responseText.replace(/</g, "&lt;").replace(/>/g, "&gt;"));
                        }
                    },
                    error: function(xhr, status, error) {
                        $("#siegeSelect").empty().append(new Option("Erreur lors du chargement des sièges", ""));
                        console.error("Erreur AJAX:", status, error);
                        console.log("Réponse:", xhr.responseText);

                        $("#debug").show().html("<strong>Réponse brute:</strong><br>" + 
                            xhr.responseText.replace(/</g, "&lt;").replace(/>/g, "&gt;"));
                    }
                });
            } else {
                $("#siegeSelect").empty().append(new Option("Sélectionnez d'abord un vol", ""));
            }
        }
        
        function extractJsonFromHtml(htmlText) {
            let jsonStartIndex = htmlText.lastIndexOf("<p>Method result:</p>");
            if (jsonStartIndex === -1) return null;
            
            jsonStartIndex += "<p>Method result:</p>".length;
            
            let jsonText = htmlText.substring(jsonStartIndex).trim();
            
            if (jsonText.startsWith("[")) {
                let jsonEndIndex = jsonText.lastIndexOf("]") + 1;
                if (jsonEndIndex > 0) {
                    jsonText = jsonText.substring(0, jsonEndIndex);
                    return JSON.parse(jsonText);
                }
            }

            throw new Error("Impossible d'extraire le JSON de la réponse");
        }
        
        $(document).ready(function() {
            $("#siegeSelect").append(new Option("Sélectionnez d'abord un vol", ""));
        });
    </script>
</head>
<body>
  <h2>Réserver un vol</h2>

  <form action="${pageContext.request.contextPath}/reservation/valider" method="post" enctype="multipart/form-data">
    <%
    String messageSuccess = (String) request.getAttribute("messageSuccess");
    String messageError = (String) request.getAttribute("messageError");
    %>
    <% if (messageSuccess != null) { %>
      <div class="alert success"><%= messageSuccess %></div>
    <% } %>
    <% if (messageError != null) { %>
      <div class="alert error"><%= messageError %></div>
    <% } %>  
    <div class="form-group">
          <label for="volSelect">Vol :</label>
          <select id="volSelect" name="volId" onchange="chargerSieges()">
              <option value="">Sélectionnez un vol</option>
              <%
                  List<Vol> vols = (List<Vol>) request.getAttribute("vols");
                  if (vols != null) {
                      for (Vol vol : vols) {
              %>
                  <option value="<%= vol.getId() %>">
                      <%= vol.getNumeroVol() %> - <%= vol.getVilleDepart().getNom() %>
                      <%= (vol.getVilleArrivee() != null ? "→ " + vol.getVilleArrivee().getNom() : "") %>
                  </option>
              <%
                      }
                  }
              %>
          </select>
      </div>

      <div class="form-group">
          <label for="siegeSelect">Siège :</label>
          <select id="siegeSelect" name="siegeId" required>
              <option value="">Sélectionnez d'abord un vol</option>
          </select>
      </div>

      <div class="form-group">
          <label for="nombrePassagers">Nombre de passagers :</label>
          <input type="number" id="nombrePassagers" name="nombrePassagers" min="1" max="5" value="1" required>
      </div>

      <label for="passeport">Passeport :</label>
      <input type="file" name="passeport" id="passeport" required>

      <button type="submit">Réserver maintenant</button>
  </form>

  <div id="debug"></div>
</body>

</html>
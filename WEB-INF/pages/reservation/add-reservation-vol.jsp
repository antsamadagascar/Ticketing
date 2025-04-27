<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="models.Vol" %>
<%
    java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
    String dateTimeNow = sdf.format(new java.util.Date());
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Réserver un vol | AirBooking</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/reservation/add-reservation.css">
</head>
<body>
    <!-- Header -->
    <div class="header">
        <div class="main-container">
            <h1><i class="fas fa-plane-departure me-2"></i>AirBooking</h1>
            <p>Réservez votre voyage en quelques clics</p>
        </div>
    </div>

    <div class="main-container">
        <!-- Progress Steps -->
        <div class="reservation-progress mb-4">
            <div class="progress-step">
                <div class="step-number active">1</div>
                <div class="step-content">
                    <h5 class="step-title">Sélection du vol</h5>
                    <p class="step-description">Choisissez votre vol et vos sièges</p>
                </div>
            </div>
            <div class="progress-step">
                <div class="step-number" id="step2">2</div>
                <div class="step-content">
                    <h5 class="step-title">Informations passagers</h5>
                    <p class="step-description">Renseignez les détails des voyageurs</p>
                </div>
            </div>
            <div class="progress-step">
                <div class="step-number" id="step3">3</div>
                <div class="step-content">
                    <h5 class="step-title">Confirmation</h5>
                    <p class="step-description">Vérifiez et confirmez votre réservation</p>
                </div>
            </div>
        </div>

        <!-- Messages de succès ou d'erreur -->
        <%
            String messageSuccess = (String) request.getAttribute("messageSuccess");
            String messageError = (String) request.getAttribute("messageError");
        %>
        <% if (messageSuccess != null) { %>
            <div class="alert alert-success">
                <i class="fas fa-check-circle me-2"></i><%= messageSuccess %>
            </div>
        <% } %>
        <% if (messageError != null) { %>
            <div class="alert alert-danger">
                <i class="fas fa-exclamation-triangle me-2"></i><%= messageError %>
            </div>
        <% } %>

        <!-- Formulaire principal -->
        <form id="reservationForm" enctype="multipart/form-data">
            <!-- Sélection du vol -->
            <div class="card mb-4">
                <div class="card-header">
                    <h3 class="mb-0"><i class="fas fa-plane me-2"></i>Choisissez votre vol</h3>
                </div>
                <div class="card-body">
                    <div class="mb-3">
                        <label for="volSelect" class="form-label">Sélectionnez un vol disponible</label>
                        <select id="volSelect" name="volId" class="form-select" onchange="reservation.loadSeats()">
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
                </div>
            </div>
            <!-- Date de réservation -->
            <div class="card mb-4">
                <div class="card-header">
                    <h3 class="mb-0"><i class="fas fa-calendar-alt me-2"></i>Date de réservation</h3>
                </div>
                <div class="card-body">
                    <div class="mb-3">
                        <label for="dateReservation" class="form-label">Choisissez une date de réservation</label>
                        <input type="datetime-local" id="dateReservation" name="dateReservation" class="form-control" required
                            value="<%= dateTimeNow %>">

                    </div>
                </div>
            </div>

            <!-- Conteneur pour les sièges -->
            <div class="card mb-4" id="siegesCard" style="display: none;">
                <div class="card-header">
                    <h3 class="mb-0"><i class="fas fa-chair me-2"></i>Sélectionnez vos sièges</h3>
                </div>
                <div class="card-body">
                    <p class="text-muted mb-3">Cliquez sur les sièges que vous souhaitez réserver. Les sièges sélectionnés apparaîtront en bleu.</p>
                    <div id="siegeContainer"></div>
                </div>
            </div>

            <!-- Section des passagers -->
            <div id="passagersSection" style="display: none;">
                <div class="card mb-4">
                    <div class="card-header">
                        <h3 class="mb-0"><i class="fas fa-users me-2"></i>Informations des passagers</h3>
                    </div>
                    <div class="card-body">
                        <p class="text-muted mb-3">Veuillez remplir les informations pour chaque passager</p>
                        <div id="passagerFormContainer"></div>
                    </div>
                </div>

                <!-- Résumé des sélections -->
                <div class="card summary-card mb-4">
                    <div class="card-header">
                        <h3 class="mb-0"><i class="fas fa-receipt me-2"></i>Résumé de votre réservation</h3>
                    </div>
                    <div class="card-body">
                        <div class="row align-items-center">
                            <div class="col-md-6">
                                <p><i class="fas fa-user-friends me-2"></i><strong>Nombre de passagers :</strong> <span id="nombrePassagersTotal">0</span></p>
                                <p><i class="fas fa-plane-departure me-2"></i><strong>Vol :</strong> <span id="volInfo">-</span></p>
                                <p><i class="fas fa-chair me-2"></i><strong>Sièges :</strong> <span id="siegeInfo">-</span></p>
                            </div>
                            <div class="col-md-6 text-md-end">
                                <p class="mb-1">Prix total</p>
                                <p class="price-total"><span id="prixTotal">0</span> €</p>
                            </div>
                        </div>
                        <div class="text-center mt-4">
                            <button type="submit" id="submitReservation" class="btn btn-primary btn-lg w-100" disabled>
                                <i class="fas fa-check-circle me-2"></i>Confirmer la réservation
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </form>
    </div>

    <!-- Scripts -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
    <script>
        window.contextPath = "${pageContext.request.contextPath}";
        
        const reservation = {
            passagerCount: 0,
            selectedSeats: new Set(),
            totalPrice: 0,
            seatDetails: [],
            volDetails: null,
        
            loadSeats() {
                const volId = document.getElementById("volSelect").value;
                const siegeContainer = document.getElementById("siegeContainer");
                const passagersSection = document.getElementById("passagersSection");
                const siegesCard = document.getElementById("siegesCard");
                
                // Mettre à jour les infos du vol
                const volSelect = document.getElementById("volSelect");
                if (volId) {
                    const selectedOption = volSelect.options[volSelect.selectedIndex];
                    this.volDetails = selectedOption.text;
                    document.getElementById("volInfo").textContent = selectedOption.text;
                }
        
                if (!volId) {
                    siegeContainer.innerHTML = "";
                    passagersSection.style.display = "none";
                    siegesCard.style.display = "none";
                    return;
                }
        
                siegeContainer.innerHTML = `
                    <div class="d-flex justify-content-center my-4">
                        <div class="spinner-border text-primary" role="status">
                            <span class="visually-hidden">Chargement...</span>
                        </div>
                        <span class="ms-3">Chargement des sièges disponibles...</span>
                    </div>
                `;
                siegesCard.style.display = "block";
        
                $.ajax({
                    url: `${window.contextPath}/Ticketing/sieges-disponibles`,
                    type: "GET",
                    data: { volId },
                    dataType: "json",
                    success: (data) => {
                        this.processSeatsData(data);
                    },
                    error: (xhr) => {
                        try {
                            const jsonData = this.extractJsonFromHtml(xhr.responseText);
                            if (jsonData && Array.isArray(jsonData)) {
                                this.processSeatsData(jsonData);
                            } else {
                                siegeContainer.innerHTML = `
                                    <div class="alert alert-danger">
                                        <i class="fas fa-exclamation-circle me-2"></i>
                                        Erreur de format des données.
                                    </div>
                                `;
                            }
                        } catch (e) {
                            siegeContainer.innerHTML = `
                                <div class="alert alert-danger">
                                    <i class="fas fa-exclamation-circle me-2"></i>
                                    Erreur lors du chargement des sièges.
                                </div>
                            `;
                        }
                    }
                });
            },
        
            processSeatsData(data) {
                const siegeContainer = document.getElementById("siegeContainer");
                siegeContainer.innerHTML = "";
                this.passagerCount = 0;
                this.selectedSeats.clear();
                this.seatDetails = [];
                this.totalPrice = 0;
                
                document.getElementById("passagerFormContainer").innerHTML = "";
                document.getElementById("siegeInfo").textContent = "-";
        
                if (!Array.isArray(data) || data.length === 0) {
                    siegeContainer.innerHTML = `
                        <div class="alert alert-warning">
                            <i class="fas fa-exclamation-triangle me-2"></i>
                            Aucun siège disponible pour ce vol.
                        </div>
                    `;
                    document.getElementById("passagersSection").style.display = "none";
                    return;
                }
        
                const siegesParType = {};

                    data.forEach((siege) => {
                        if (!siege || !siege.id || !siege.numero) return;

                        const type = siege.type?.trim() || "Standard";

                        if (!siegesParType[type]) {
                            siegesParType[type] = [];
                        }

                        const seatData = {
                            id: siege.id,
                            numero: siege.numero,
                            type,
                            prix: typeof siege.prix === "number" ? siege.prix : 0
                        };

                        siegesParType[type].push(seatData);
                        this.seatDetails.push(seatData);
                    });

                    console.log("siegesParType:", siegesParType);

                const legende = document.createElement("div");
                legende.className = "mb-4 d-flex flex-wrap gap-3 justify-content-center";
                legende.innerHTML = `
                    <div class="d-flex align-items-center">
                        <div class="siege me-2" style="width: 30px; height: 30px; background-color: #f8f9fa;"></div>
                        <span>Disponible</span>
                    </div>
                    <div class="d-flex align-items-center">
                        <div class="siege me-2 selected" style="width: 30px; height: 30px;"></div>
                        <span>Sélectionné</span>
                    </div>
                `;
                siegeContainer.appendChild(legende);
        
                const typesContainer = document.createElement("div");
                typesContainer.className = "siege-types-container";
        
                Object.keys(siegesParType).forEach((type) => {
                    const sieges = siegesParType[type];
    
                    const typeContainer = document.createElement("div");
                    typeContainer.className = "siege-type";
        
                    const titleElement = document.createElement("h3");

                    const prix = `${sieges[0].prix.toFixed(2)} €`;
                    // console.log("Type:", type);
                    // console.log("Premier siège du type:", sieges[0]);
                    // console.log("Prix brut:", sieges[0].prix);

                    titleElement.innerHTML = '';
                        const iconElement = document.createElement('i');
                        iconElement.className = 'fas fa-tag me-2';

                        const typeSpan = document.createElement('span');
                        typeSpan.textContent = type;
                        typeSpan.style.fontWeight = 'bold';

                        // const priceSpan = document.createElement('span');
                        // priceSpan.textContent = ` - Prix: ${prix}`;

                        titleElement.appendChild(iconElement);
                        titleElement.appendChild(typeSpan);
                    //    titleElement.appendChild(priceSpan);
                    
                        typeContainer.appendChild(titleElement);
        
                    const siegeGrid = document.createElement("div");
                    siegeGrid.className = "siege-grid";
        
                    sieges.forEach((siege) => {
                        const siegeElement = document.createElement("div");
                        siegeElement.className = "siege";
                        siegeElement.dataset.id = siege.id;
                        siegeElement.dataset.numero = siege.numero;
                        siegeElement.dataset.prix = siege.prix;
                        siegeElement.dataset.type = siege.type;
                        siegeElement.textContent = siege.numero;
                        siegeElement.addEventListener("click", () => this.toggleSeatSelection(siegeElement, siege));
                        siegeGrid.appendChild(siegeElement);
                    });
        
                    typeContainer.appendChild(siegeGrid);
                    typesContainer.appendChild(typeContainer);
                });
        
                siegeContainer.appendChild(typesContainer);
                document.getElementById("passagersSection").style.display = "block";
                document.getElementById("step2").classList.add("active");
                this.updateSummary();
            },
        
            toggleSeatSelection(element, siege) {
                const seatId = siege.id;
                const seatPrice = siege.prix;
                
                if (element.classList.contains("selected")) {
                    element.classList.remove("selected");
                    this.selectedSeats.delete(seatId);
                    document.getElementById(`passager-form-${seatId}`)?.remove();
                    this.passagerCount--;
                    this.totalPrice -= seatPrice;
                } else {
                    element.classList.add("selected");
                    this.selectedSeats.add(seatId);
                    this.addPassengerForm(siege);
                    this.passagerCount++;
                    this.totalPrice += seatPrice;
                }
                
                this.updateSummary();
     
                // Mettre à jour les infos des sièges
                const selectedSeatsInfo = Array.from(this.selectedSeats).map(id => {
                    const seat = this.seatDetails.find(s => s.id === id);
                    console.log("Construction pour siège:", seat);
                    
                    if (!seat) {
                        console.warn("Siège non trouvé pour l'ID:", id);
                        return '';
                    }
                    
                    // Récupération explicite des valeurs avec valeurs par défaut
                    const numero = seat.numero ? seat.numero : "?";
                    const type = seat.type ? seat.type : "Standard";
                    
               //     console.log(`Numéro: "${numero}", Type: "${type}"`);
                    
                    // Construction explicite de la chaîne
                    const infoText = numero + " (" + type + ")";
                 //   console.log("Texte construit:", infoText);
                    
                    return infoText;
                }).filter(Boolean).join(", ");

               // console.log("Info finale des sièges:", selectedSeatsInfo);

                document.getElementById("siegeInfo").textContent = selectedSeatsInfo || "-";
            },
        
            addPassengerForm(siege) {
                const container = document.getElementById("passagerFormContainer");
                const form = document.createElement("div");
                form.id = `passager-form-${siege.id}`;
                form.className = "passager-form";
                form.dataset.seatId = siege.id;
                const seatType = siege.type;
                
                form.innerHTML = `
                    <h4><i class="fas fa-user me-2"></i>Passager - Siège ${siege.numero} (${seatType})</h4>
                    <input type="hidden" name="siegeId" value="${siege.id}">
                    <div class="form-row">
                        <div class="form-group">
                            <label for="nom-${siege.id}">Nom</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="fas fa-user"></i></span>
                                <input type="text" id="nom-${siege.id}" name="nom" class="form-control" required placeholder="Nom de famille">
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="prenom-${siege.id}">Prénom</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="fas fa-user"></i></span>
                                <input type="text" id="prenom-${siege.id}" name="prenom" class="form-control" required placeholder="Prénom">
                            </div>
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="form-group">
                            <label for="dateNaissance-${siege.id}">Date de naissance</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="fas fa-calendar"></i></span>
                                <input type="date" id="dateNaissance-${siege.id}" name="dateNaissance" class="form-control" required>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="passeport-${siege.id}">Passeport (PDF, JPG, PNG)</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="fas fa-passport"></i></span>
                                <input type="file" id="passeport-${siege.id}" name="passeport" class="form-control" accept=".pdf,.jpg,.png" required>
                            </div>
                        </div>
                    </div>
                `;
                container.appendChild(form);
            },
        
            updateSummary() {
                document.getElementById("nombrePassagersTotal").textContent = this.passagerCount;
                document.getElementById("prixTotal").textContent = this.totalPrice.toFixed(2);
                
                const submitButton = document.getElementById("submitReservation");
                submitButton.disabled = this.passagerCount === 0;
                
                if (this.passagerCount > 0) {
                    document.getElementById("step3").classList.add("active");
                } else {
                    document.getElementById("step3").classList.remove("active");
                }
            },
        
            extractJsonFromHtml(htmlText) {
                try {
                    const jsonMatch = htmlText.match(/\[.*\]/s);
                    if (jsonMatch) {
                        return JSON.parse(jsonMatch[0]);
                    }
                    return null;
                } catch (e) {
                    return null;
                }
            },
        
            init() {
                document.getElementById("reservationForm").addEventListener("submit", (e) => {
                    e.preventDefault();
                    
                    // Animation du bouton
                    const submitBtn = document.getElementById("submitReservation");
                    const originalBtnText = submitBtn.innerHTML;
                    submitBtn.innerHTML = `
                        <span class="spinner-border spinner-border-sm me-2" role="status" aria-hidden="true"></span>
                        Traitement en cours...
                    `;
                    submitBtn.disabled = true;
                    
                    const formData = new FormData();
        
                    const volId = document.getElementById("volSelect").value;
                    const dateReservation = document.getElementById("dateReservation").value;
                    const nombrePassagers = this.passagerCount;
                    const siegeIds = Array.from(this.selectedSeats);
                    const passagers = [];
                    const passeportFiles = [];
        
                    const passengerForms = document.querySelectorAll(".passager-form");
                    if (passengerForms.length === 0) {
                       alert("Erreur : Aucun formulaire passager trouvé.", "danger");
                        submitBtn.innerHTML = originalBtnText;
                        submitBtn.disabled = false;
                        return;
                    }
        
                    for (const form of passengerForms) {
                        const seatId = form.dataset.seatId;
                        const nom = form.querySelector("input[name='nom']").value.trim();
                        const prenom = form.querySelector("input[name='prenom']").value.trim();
                        const dateNaissance = form.querySelector("input[name='dateNaissance']").value;
                        const passeport = form.querySelector("input[name='passeport']").files[0];
        
                        if (!nom || !prenom || !dateNaissance || !passeport) {
                            alert("Tous les champs doivent être remplis pour chaque passager.", "danger");
                            submitBtn.innerHTML = originalBtnText;
                            submitBtn.disabled = false;
                            return;
                        }
        
                        const formattedDate = new Date(dateNaissance).toISOString().split('T')[0];
                        passagers.push({ nom, prenom, dateNaissance: formattedDate, passeport: passeport.name });
                        passeportFiles.push(passeport);
                    }
        
                    if (passagers.length !== nombrePassagers || passeportFiles.length !== nombrePassagers) {
                       alert("Erreur : incohérence dans les données des passagers.", "danger");
                        submitBtn.innerHTML = originalBtnText;
                        submitBtn.disabled = false;
                        return;
                    }
        
                    formData.append("volId", volId);
                    formData.append("dateReservation", dateReservation);
                    formData.append("nombrePassagers", nombrePassagers);
                    siegeIds.forEach(id => formData.append("siegeId", id));
                    formData.append("passagers", JSON.stringify(passagers));
                    passeportFiles.forEach(file => formData.append("passeport", file));
        
                    $.ajax({
                        url: `${window.contextPath}/Ticketing/reservation/valider`,
                        type: "POST",
                        data: formData,
                        processData: false,
                        contentType: false,

                        success: (response) => {
                            console.log("Réponse de succès reçue:", response);
                            alert("Réservation effectuée avec succès! Vous allez être redirigé.", "success");
                            
                            setTimeout(() => {
                                location.reload();
                            }, 3000);
                        },
                        error: (xhr) => {
                            console.log("Erreur reçue:", xhr);
                            alert("Erreur lors de la réservation. Veuillez réessayer.", "danger");
                            console.error(xhr.responseText);
                            submitBtn.innerHTML = originalBtnText;
                            submitBtn.disabled = false;
}
                    });
                });
            },
            
            showAlert(message, type) {
                // Créer une alerte dynamique
                const alertContainer = document.createElement('div');
                alertContainer.className = `alert alert-${type} alert-dismissible fade show`;
                alertContainer.role = 'alert';
                
                // Ajouter l'icône appropriée
                let icon = 'info-circle';
                if (type === 'success') icon = 'check-circle';
                if (type === 'danger') icon = 'exclamation-triangle';
                if (type === 'warning') icon = 'exclamation-circle';
                
                alertContainer.innerHTML = `
                    <i class="fas fa-${icon} me-2"></i>
                    ${message}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                `;
                
                // Trouver un conteneur valide et y insérer l'alerte
                // Essayez plusieurs sélecteurs possibles au cas où .main-container n'existe pas
                const mainContainer = document.querySelector('.main-container') || 
                                    document.querySelector('.container') || 
                                    document.querySelector('main') ||
                                    document.body;
                
                // Insérer au début du conteneur
                if (mainContainer.firstChild) {
                    mainContainer.insertBefore(alertContainer, mainContainer.firstChild);
                } else {
                    mainContainer.appendChild(alertContainer);
                }
                
                // Débogage - confirmer que l'alerte a été créée
             //   console.log("Alerte créée:", alertContainer);
                
                // Faire défiler vers le haut pour voir l'alerte
                window.scrollTo({ top: 0, behavior: 'smooth' });
                
                // Supprimer automatiquement après 5 secondes
                setTimeout(() => {
                    alertContainer.classList.remove('show');
                    setTimeout(() => alertContainer.remove(), 300);
                }, 5000);
            }
        };
        
        document.addEventListener("DOMContentLoaded", () => {
            reservation.init();
            
            // Animation d'apparition des éléments au chargement
            const fadeInElements = document.querySelectorAll('.card, .progress-step');
            fadeInElements.forEach((element, index) => {
                setTimeout(() => {
                    element.style.opacity = '0';
                    element.style.transform = 'translateY(20px)';
                    element.style.transition = 'opacity 0.5s ease, transform 0.5s ease';
                    
                    setTimeout(() => {
                        element.style.opacity = '1';
                        element.style.transform = 'translateY(0)';
                    }, 100 * index);
                }, 0);
            });
        });
    </script>
</body>
</html>

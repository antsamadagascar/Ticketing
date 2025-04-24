<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tableau de bord utilisateur</title>
    <link href="${pageContext.request.contextPath}/assets/css/all.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/home.admin.css" rel="stylesheet">
</head>
<body>
    <div class="dashboard-container">
        <!-- Section de bienvenue -->
        <div class="welcome-section">
            <h1 class="welcome-title">Espace personnel</h1>
            <p class="welcome-subtitle">
                Bienvenue dans votre tableau de bord. Gérez vos voyages et retrouvez tous vos services.
            </p>
            <div class="user-info">
                <i class="fas fa-user"></i>
                <span>Connecté en tant que ${sessionScope.authUser.nom} ${sessionScope.authUser.prenom}</span>
            </div>
        </div>

        <!-- Grille des fonctionnalités -->
        <div class="cards-grid">
            <!-- Recherche de vols -->
            <div class="feature-card search">
                <div class="stats-badge">Explorer</div>
                <div class="card-icon">
                    <i class="fas fa-search-location"></i>
                </div>
                <h3 class="card-title">Recherche de vols</h3>
                <p class="card-description">
                    Explorez notre réseau de destinations. Filtrez par ville, date, classe et trouvez le vol idéal.
                </p>
                <div class="card-action">
                    <a href="${pageContext.request.contextPath}/recherche" class="btn-action btn-flights">
                        <i class="fas fa-search"></i>
                        <span>Explorer les vols</span>
                    </a>
                </div>
            </div>

            <!-- Réservation -->
            <div class="feature-card booking">
                <div class="stats-badge">Réservation</div>
                <div class="card-icon">
                    <i class="fas fa-ticket-alt"></i>
                </div>
                <h3 class="card-title">Réserver un vol</h3>
                <p class="card-description">
                    Sélectionnez vos vols, ajoutez les passagers et finalisez votre voyage en quelques clics.
                </p>
                <div class="card-action">
                    <a href="${pageContext.request.contextPath}/reservation-vol" class="btn-action btn-promotions">
                        <i class="fas fa-plus-circle"></i>
                        <span>Réserver maintenant</span>
                    </a>
                </div>
            </div>

            <!-- Mes réservations -->
            <div class="feature-card reservations">
                <div class="stats-badge">Historique</div>
                <div class="card-icon">
                    <i class="fas fa-clipboard-list"></i>
                </div>
                <h3 class="card-title">Mes réservations</h3>
                <p class="card-description">
                    Consultez l’historique de vos voyages, imprimez vos billets ou annulez si nécessaire.
                </p>
                <div class="card-action">
                    <a href="${pageContext.request.contextPath}/mes-reservation" class="btn-action btn-reservations">
                        <i class="fas fa-list-alt"></i>
                        <span>Voir mes réservations</span>
                    </a>
                </div>
            </div>
        </div>
    </div>
</body>
</html>

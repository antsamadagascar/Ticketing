<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard Administration</title>
    <link href="${pageContext.request.contextPath}/assets/css/all.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/home.admin.css" rel="stylesheet">
</head>
<body>
    <div class="dashboard-container">
        <!-- Section de bienvenue -->
        <div class="welcome-section">
            <h1 class="welcome-title">
                Tableau de bord administrateur
            </h1>
            <p class="welcome-subtitle">
                Gérez efficacement votre système de réservation de vols avec ces outils d'administration avancés
            </p>
            <div class="user-info">
                <i class="fas fa-user-shield"></i>
                <span>Connecté en tant que ${sessionScope.authUser.nom} ${sessionScope.authUser.prenom}</span>
            </div>
        </div>

        <!-- Grille des fonctionnalités -->
        <div class="cards-grid">
            <!-- Gestion des vols -->
            <div class="feature-card flights">
                <div class="stats-badge">Module principal</div>
                <div class="card-icon">
                    <i class="fas fa-plane"></i>
                </div>
                <h3 class="card-title">Gestion des vols</h3>
                <p class="card-description">
                    Administrez l'ensemble de votre flotte : créez de nouveaux vols, modifiez les horaires et itinéraires, 
                    gérez les capacités et consultez l'historique complet des vols.
                </p>
                <div class="card-action">
                    <a href="/Ticketing/vols" class="btn-action btn-flights">
                        <i class="fas fa-plane-departure"></i>
                        <span>Gérer les vols</span>
                    </a>
                </div>
            </div>

            <!-- Promotions -->
            <div class="feature-card promotions">
                <div class="stats-badge">Tarification</div>
                <div class="card-icon">
                    <i class="fas fa-tags"></i>
                </div>
                <h3 class="card-title">Promotions par classe</h3>
                <p class="card-description">
                    Configurez des promotions attractives selon les classes de service : Économique, Affaires, Première classe. 
                    Optimisez vos taux d'occupation et revenus.
                </p>
                <div class="card-action">
                    <a href="/Ticketing/promotions" class="btn-action btn-promotions">
                        <i class="fas fa-percentage"></i>
                        <span>Configurer les promotions</span>
                    </a>
                </div>
            </div>

            <!-- Règles de réservation -->
            <div class="feature-card reservations">
                <div class="stats-badge">Politique</div>
                <div class="card-icon">
                    <i class="fas fa-calendar-check"></i>
                </div>
                <h3 class="card-title">Règles de réservation</h3>
                <p class="card-description">
                    Définissez le délai minimum requis entre la réservation et le départ du vol. 
                    Assurez un traitement optimal des réservations de dernière minute.
                </p>
                <div class="card-action">
                    <a href="/Ticketing/regles-reservation" class="btn-action btn-reservations">
                        <i class="fas fa-clock"></i>
                        <span>Définir les règles</span>
                    </a>
                </div>
            </div>

            <!-- Règles d'annulation -->
            <div class="feature-card cancellations">
                <div class="stats-badge">Politique</div>
                <div class="card-icon">
                    <i class="fas fa-ban"></i>
                </div>
                <h3 class="card-title">Règles d'annulation</h3>
                <p class="card-description">
                    Établissez les conditions d'annulation : délais autorisés, frais applicables et processus de remboursement. 
                    Protégez vos revenus tout en restant flexible.
                </p>
                <div class="card-action">
                    <a href="/Ticketing/regles-annulation" class="btn-action btn-cancellations">
                        <i class="fas fa-undo-alt"></i>
                        <span>Gérer les annulations</span>
                    </a>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
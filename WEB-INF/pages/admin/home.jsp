<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard Administration</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        .dashboard-container {
            max-width: 1200px;
            margin: 0 auto;
        }

        .welcome-section {
            background: white;
            border-radius: 16px;
            padding: 40px 30px;
            margin-bottom: 30px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            text-align: center;
            position: relative;
            overflow: hidden;
        }

        .welcome-section::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, #667eea, #764ba2);
        }

        .welcome-title {
            font-size: 28px;
            color: #2c3e50;
            margin-bottom: 12px;
            font-weight: 600;
        }

        .welcome-subtitle {
            color: #7f8c8d;
            font-size: 16px;
            max-width: 600px;
            margin: 0 auto;
            line-height: 1.6;
        }

        .user-info {
            display: inline-flex;
            align-items: center;
            background: #f8f9fa;
            padding: 12px 20px;
            border-radius: 25px;
            margin-top: 20px;
            color: #495057;
            font-weight: 500;
        }

        .user-info i {
            margin-right: 10px;
            color: #667eea;
        }

        .cards-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 25px;
            margin-top: 20px;
        }

        .feature-card {
            background: white;
            border-radius: 12px;
            padding: 30px;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.08);
            transition: all 0.3s ease;
            position: relative;
            border-left: 4px solid transparent;
            height: 100%;
            display: flex;
            flex-direction: column;
        }

        .feature-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.15);
        }

        .feature-card.flights {
            border-left-color: #3498db;
        }

        .feature-card.promotions {
            border-left-color: #17a2b8;
        }

        .feature-card.reservations {
            border-left-color: #28a745;
        }

        .feature-card.cancellations {
            border-left-color: #ffc107;
        }

        .card-icon {
            width: 60px;
            height: 60px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 24px;
            color: white;
            margin-bottom: 20px;
        }

        .flights .card-icon {
            background: linear-gradient(135deg, #3498db, #2980b9);
        }

        .promotions .card-icon {
            background: linear-gradient(135deg, #17a2b8, #138496);
        }

        .reservations .card-icon {
            background: linear-gradient(135deg, #28a745, #1e7e34);
        }

        .cancellations .card-icon {
            background: linear-gradient(135deg, #ffc107, #e0a800);
        }

        .card-title {
            font-size: 20px;
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 12px;
        }

        .card-description {
            color: #6c757d;
            line-height: 1.6;
            margin-bottom: 25px;
            flex-grow: 1;
        }

        .card-action {
            margin-top: auto;
        }

        .btn-action {
            display: inline-flex;
            align-items: center;
            padding: 12px 24px;
            border-radius: 8px;
            text-decoration: none;
            font-weight: 500;
            transition: all 0.3s ease;
            border: 2px solid;
            background: transparent;
            position: relative;
            overflow: hidden;
        }

        .btn-action::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            transition: left 0.3s ease;
            z-index: 0;
        }

        .btn-action span {
            position: relative;
            z-index: 1;
        }

        .btn-action i {
            margin-right: 8px;
            position: relative;
            z-index: 1;
        }

        .btn-flights {
            color: #3498db;
            border-color: #3498db;
        }

        .btn-flights::before {
            background: #3498db;
        }

        .btn-flights:hover {
            color: white;
        }

        .btn-flights:hover::before {
            left: 0;
        }

        .btn-promotions {
            color: #17a2b8;
            border-color: #17a2b8;
        }

        .btn-promotions::before {
            background: #17a2b8;
        }

        .btn-promotions:hover {
            color: white;
        }

        .btn-promotions:hover::before {
            left: 0;
        }

        .btn-reservations {
            color: #28a745;
            border-color: #28a745;
        }

        .btn-reservations::before {
            background: #28a745;
        }

        .btn-reservations:hover {
            color: white;
        }

        .btn-reservations:hover::before {
            left: 0;
        }

        .btn-cancellations {
            color: #ffc107;
            border-color: #ffc107;
        }

        .btn-cancellations::before {
            background: #ffc107;
        }

        .btn-cancellations:hover {
            color: #212529;
        }

        .btn-cancellations:hover::before {
            left: 0;
        }

        .stats-badge {
            position: absolute;
            top: 15px;
            right: 15px;
            background: rgba(0, 0, 0, 0.05);
            color: #6c757d;
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 500;
        }

        @media (max-width: 768px) {
            .welcome-section {
                padding: 30px 20px;
            }

            .welcome-title {
                font-size: 24px;
            }

            .cards-grid {
                grid-template-columns: 1fr;
                gap: 20px;
            }

            .feature-card {
                padding: 25px;
            }
        }

        @media (max-width: 480px) {
            body {
                padding: 15px;
            }

            .welcome-section {
                padding: 25px 15px;
            }

            .welcome-title {
                font-size: 22px;
            }

            .feature-card {
                padding: 20px;
            }
        }
    </style>
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
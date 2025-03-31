<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<header class="navbar navbar-dark sticky-top bg-primary flex-md-nowrap p-0 shadow custom-header">
    <!-- Bouton de bascule pour la sidebar à gauche -->
    <button class="navbar-toggler d-md-none collapsed" type="button" 
            data-bs-toggle="offcanvas" data-bs-target="#sidebarMenu" 
            aria-controls="sidebarMenu" aria-expanded="false" aria-label="Toggle navigation">
        <span class="navbar-toggler-icon"></span>
    </button>

    <!-- Conteneur pour les éléments alignés à droite -->
    <div class="navbar-nav ms-auto d-flex flex-row align-items-center">

        <!-- Menu déroulant pour le compte utilisateur -->
        <div class="nav-item dropdown">
            <a class="nav-link dropdown-toggle px-3" href="#" id="accountDropdown" role="button" 
               data-bs-toggle="dropdown" aria-expanded="false">
                <i class="fas fa-user"></i> 
                ${sessionScope.authUser.nom} ${sessionScope.authUser.prenom}
            </a>
            <ul class="dropdown-menu" aria-labelledby="accountDropdown">
                <li>
                    <a class="dropdown-item d-flex align-items-center" href="#">
                        <i class="fas fa-envelope me-2"></i> ${sessionScope.authUser.email}
                    </a>
                </li>
                <li>
                    <a class="dropdown-item d-flex align-items-center" href="#">
                        <i class="fas fa-user-tag me-2"></i> ${sessionScope.rolesUser}
                    </a>
                </li>
                <li><hr class="dropdown-divider"></li>
                <li>
                    <a href="${pageContext.request.contextPath}/logout" class="dropdown-item d-flex align-items-center">
                        <i class="bi bi-box-arrow-right me-2"></i> Déconnexion
                    </a>
                </li>
                
            </ul>
        </div>
        
        <!-- Sélecteur de thème -->
        <div class="nav-item dropdown">
            <a class="nav-link dropdown-toggle px-3" href="#" id="themeDropdown" role="button" 
               data-bs-toggle="dropdown" aria-expanded="false">Thème
                <i class="fas fa-palette"></i>
            </a>
            <ul class="dropdown-menu" aria-labelledby="themeDropdown">
                <li><a class="dropdown-item" href="#" onclick="changeTheme('default')">Thème par défaut</a></li>
                <li><a class="dropdown-item" href="#" onclick="changeTheme('light')">Thème clair</a></li>
                <li><a class="dropdown-item" href="#" onclick="changeTheme('blue')">Thème bleu</a></li>
                <li><a class="dropdown-item" href="#" onclick="changeTheme('green')">Thème vert</a></li>
                <li><a class="dropdown-item" href="#" onclick="changeTheme('violet')">Thème violet</a></li>
                <li><a class="dropdown-item" href="#" onclick="changeTheme('red')">Thème rouge</a></li>
            </ul>
        </div>

        
         
    </div>
</header>





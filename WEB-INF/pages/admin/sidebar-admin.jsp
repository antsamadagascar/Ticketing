<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<div class="container-fluid">
    <div class="row">
        <!-- Sidebar à gauche -->
        <nav id="sidebarMenu" class="col-md-3 col-lg-2 d-md-block bg-light sidebar offcanvas offcanvas-start offcanvas-md" tabindex="-1" aria-labelledby="sidebarMenuLabel">
            <div class="offcanvas-header">
                <h5 class="offcanvas-title" id="sidebarMenuLabel">Air Ticket</h5>
                <button type="button" class="btn-close" data-bs-dismiss="offcanvas" aria-label="Close"></button>
            </div>
            <div class="offcanvas-body">
                <div class="sidebar-header d-flex flex-column align-items-center py-4">
                    <img src="${pageContext.request.contextPath}/assets/logos/flight.png" alt="Logo" class="img-fluid mb-2" style="max-height: 60px;">
                    <h5 class="mb-0">Air Ticket</h5>
                </div>
                
                <hr>
                <div class="position-sticky pt-3">
                    <ul class="nav flex-column">
                        
                        <li class="nav-item">
                            <a class="nav-link {{ request()->is('vols*') ? 'active' : '' }}" href="${pageContext.request.contextPath}/vols">
                                <i class="fas fa-plane"></i> Vols
                            </a>
                        </li>
                        
                        <hr>
                        <h6 class="sidebar-heading d-flex justify-content-between align-items-center px-3 mt-4 mb-1 text-muted">
                            <span>Configuration</span>
                        </h6>
                        <li class="nav-item">
                            <a href="${pageContext.request.contextPath}/promotions" class="nav-link {{ request()->is('promotions*') ? 'active' : '' }}">
                                <i class="fas fa-tags"></i> Promotion par vol
                            </a>
                            <a href="${pageContext.request.contextPath}/regles-reservation" class="nav-link {{ request()->is('regles-reservation*') ? 'active' : '' }}">
                                <i class="fas fa-calendar-check"></i> Réservation
                            </a>
                            <a href="${pageContext.request.contextPath}/regles-annulation" class="nav-link {{ request()->is('regles-annulation*') ? 'active' : '' }}">
                                <i class="fas fa-ban"></i> Annulation réservation
                            </a>
                        </li>
                    </ul>
                </div>
            </div>
        </nav>

        <!-- Contenu principal -->
        <main class="col-md-9 ms-md-auto col-lg-10 px-md-4">
            <!-- Votre contenu principal ici -->
        </main>
    </div>
</div>
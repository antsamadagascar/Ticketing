<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Espace Login</title>
    <link href="${pageContext.request.contextPath}/assets/css/all.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/login.css" rel="stylesheet">
    <script src="${pageContext.request.contextPath}/assets/css/3.4.16"></script>
</head>
<body>
    <div class="login-container">
        <div class="login-card">
            <div class="login-header">
                <div class="login-icon">
                    <i class="fas fa-globe"></i>
                </div>
                <h1 class="login-title">Connexion</h1>
            </div>
            
            <% if (request.getAttribute("error") != null) { %>
                <div class="error-message">
                    <i class="fas fa-exclamation-circle"></i>
                    <%= request.getAttribute("error") %>
                </div>
            <% } %>
            
            <form action="${pageContext.request.contextPath}/auth/login" method="post" id="loginForm">
                <div class="form-group">
                    <label for="username" class="form-label">Email ou nom d'utilisateur</label>
                    <div class="input-container">
                        <i class="fas fa-user input-icon"></i>
                        <input 
                            type="email" 
                            id="username" 
                            name="email" 
                            class="form-input" 
                            placeholder="Entrez votre email"
                            value="<%= request.getAttribute("email") != null ? request.getAttribute("email") : "" %>"
                            autocomplete="username" 
                            autofocus
                            
                        >
                    </div>
                    <% if (request.getAttribute("emailError") != null) { %>
                        <div class="error-message">
                            <i class="fas fa-exclamation-circle"></i>
                            <%= request.getAttribute("emailError") %>
                        </div>
                    <% } %>
                </div>
                
                <div class="form-group">
                    <label for="password" class="form-label">Mot de passe</label>
                    <div class="input-container">
                        <i class="fas fa-lock input-icon"></i>
                        <input 
                            type="password" 
                            id="password" 
                            name="password" 
                            class="form-input" 
                            placeholder="Entrez votre mot de passe"
                            autocomplete="current-password"
                            
                        >
                        <button type="button" class="password-toggle" id="togglePassword" aria-label="Afficher le mot de passe">
                            <i class="fas fa-eye"></i>
                        </button>
                    </div>
                    <% if (request.getAttribute("motDePasseError") != null) { %>
                        <div class="error-message">
                            <i class="fas fa-exclamation-circle"></i>
                            <%= request.getAttribute("motDePasseError") %>
                        </div>
                    <% } %>
                </div>
                
                <button type="submit" class="login-button" id="submitButton">
                    <div class="loading-spinner" id="spinner"></div>
                    <span id="buttonText">Se connecter</span>
                </button>
            </form>
        </div>
    </div>
    
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const form = document.getElementById('loginForm');
            const submitButton = document.getElementById('submitButton');
            const spinner = document.getElementById('spinner');
            const buttonText = document.getElementById('buttonText');
            const passwordInput = document.getElementById('password');
            const toggleButton = document.getElementById('togglePassword');
            
            // Gestion de la soumission du formulaire
            form.addEventListener('submit', function() {
                submitButton.disabled = true;
                spinner.classList.add('show');
                buttonText.textContent = 'Connexion en cours...';
            });
            
            // Toggle du mot de passe
            toggleButton.addEventListener('click', function() {
                const isPassword = passwordInput.type === 'password';
                passwordInput.type = isPassword ? 'text' : 'password';
                
                const icon = this.querySelector('i');
                icon.classList.toggle('fa-eye');
                icon.classList.toggle('fa-eye-slash');
                
                this.setAttribute('aria-label', isPassword ? 'Masquer le mot de passe' : 'Afficher le mot de passe');
            });
        });
    </script>
</body>
</html>
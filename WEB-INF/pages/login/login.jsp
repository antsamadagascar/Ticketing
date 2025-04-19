<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Espace Login</title>
    <link href="${pageContext.request.contextPath}/assets/css/all.min.css" rel="stylesheet">
    <script src="${pageContext.request.contextPath}/assets/css/3.4.16"></script>
    <style>
        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f7f9fc;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
            line-height: 1.6;
        }
        
        .login-container {
            width: 100%;
            max-width: 400px;
        }
        
        .login-card {
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            padding: 40px 30px;
            border: 1px solid #e1e8ed;
        }
        
        .login-header {
            text-align: center;
            margin-bottom: 30px;
        }
        
        .login-icon {
            width: 60px;
            height: 60px;
            background: #4a90e2;
            color: white;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 20px;
            font-size: 24px;
        }
        
        .login-title {
            font-size: 24px;
            color: #2c3e50;
            font-weight: 400;
            margin: 0;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-label {
            display: block;
            color: #34495e;
            margin-bottom: 8px;
            font-weight: 500;
            font-size: 14px;
        }
        
        .input-container {
            position: relative;
        }
        
        .form-input {
            width: 100%;
            padding: 12px 16px 12px 45px;
            border: 2px solid #e1e8ed;
            border-radius: 6px;
            font-size: 16px;
            background: white;
            transition: border-color 0.2s ease;
        }
        
        .form-input:focus {
            outline: none;
            border-color: #4a90e2;
            box-shadow: 0 0 0 3px rgba(74, 144, 226, 0.1);
        }
        
        .input-icon {
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: #7f8c8d;
            font-size: 16px;
        }
        
        .password-toggle {
            position: absolute;
            right: 15px;
            top: 50%;
            transform: translateY(-50%);
            background: none;
            border: none;
            color: #7f8c8d;
            cursor: pointer;
            padding: 4px;
            border-radius: 4px;
        }
        
        .password-toggle:hover {
            color: #4a90e2;
            background: rgba(74, 144, 226, 0.1);
        }
        
        .error-message {
            color: #e74c3c;
            font-size: 14px;
            margin-top: 8px;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .login-button {
            width: 100%;
            background: #4a90e2;
            color: white;
            border: none;
            padding: 14px;
            border-radius: 6px;
            font-size: 16px;
            font-weight: 500;
            cursor: pointer;
            transition: background-color 0.2s ease;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
        }
        
        .login-button:hover:not(:disabled) {
            background: #357abd;
        }
        
        .login-button:disabled {
            background: #bdc3c7;
            cursor: not-allowed;
        }
        
        .loading-spinner {
            width: 18px;
            height: 18px;
            border: 2px solid transparent;
            border-top: 2px solid white;
            border-radius: 50%;
            animation: spin 1s linear infinite;
            display: none;
        }
        
        .loading-spinner.show {
            display: block;
        }
        
        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
        
        /* Responsive */
        @media (max-width: 480px) {
            .login-card {
                padding: 30px 20px;
            }
        }
        
        /* Accessibility */
        .form-input:focus,
        .password-toggle:focus,
        .login-button:focus {
            outline: 2px solid #4a90e2;
            outline-offset: 2px;
        }
    </style>
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
                            required
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
                            required
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
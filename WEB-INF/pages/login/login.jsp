<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Espace Login</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
    <script src="${pageContext.request.contextPath}/assets/css/3.4.16"></script>
    <style>
        .login-bg {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }
    </style>
</head>
<body class="login-bg min-h-screen flex items-center justify-center px-4 py-8">
    <div class="w-full max-w-md">
        <div class="bg-white shadow-2xl rounded-2xl overflow-hidden transform transition-all duration-300 hover:scale-105">
            <div class="p-8">
                <div class="flex justify-center mb-6">
                    <div class="w-24 h-24 bg-gradient-to-br from-purple-500 to-indigo-600 rounded-full flex items-center justify-center shadow-lg">
                        <i class="fas fa-globe text-4xl text-white"></i>
                    </div>
                </div>
                
                <h2 class="text-center text-3xl font-extrabold text-gray-800 mb-6">
                  Login
                </h2>
                
                <% if (request.getAttribute("error") != null) { %>
                        <p class="text-red-500 text-sm mt-2 flex items-center"><i class="fas fa-info-circle mr-2"></i><%= request.getAttribute("error") %></p>
                <% } %>
                <form action="${pageContext.request.contextPath}/auth/login" method="post" id="loginForm">
                    <div class="mb-4">
                        <label for="username" class="block text-gray-700 font-semibold mb-2">Username or Email</label>
                        <div class="relative">
                            <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                                <i class="fas fa-user text-gray-400"></i>
                            </div>
                            <input type="email" id="username" name="email" class="w-full pl-10 pr-3 py-3 border-2 rounded-lg focus:outline-none focus:border-indigo-500 transition duration-300" placeholder="Enter your username or email" value="<%= request.getAttribute("email") != null ? request.getAttribute("email") : "" %>" autocomplete="username" autofocus>
                        </div>
                        <% if (request.getAttribute("emailError") != null) { %>
                            <p class="text-red-500 text-sm mt-2 flex items-center"><i class="fas fa-info-circle mr-2"></i><%= request.getAttribute("emailError") %></p>
                        <% } %>
                    </div>
                    <div class="mb-6">
                        <div class="flex justify-between items-center mb-2">
                            <label for="password" class="block text-gray-700 font-semibold">Password</label>
                           <!--<a href="#" class="text-sm text-indigo-600 hover:text-indigo-500">Forgot password?</a> -->
                        </div>
                        <div class="relative">
                            <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                                <i class="fas fa-lock text-gray-400"></i>
                            </div>
                            <input type="password" id="password" name="password" class="w-full pl-10 pr-10 py-3 border-2 rounded-lg focus:outline-none focus:border-indigo-500 transition duration-300" placeholder="Enter your password" autocomplete="current-password">
                            <div class="absolute inset-y-0 right-0 pr-3 flex items-center">
                                <button type="button" id="togglePassword" class="text-gray-400 hover:text-gray-600">
                                    <i class="fas fa-eye"></i>
                                </button>
                            </div>
                        </div>
                        <% if (request.getAttribute("motDePasseError") != null) { %>
                            <p class="text-red-500 text-sm mt-2 flex items-center"><i class="fas fa-info-circle mr-2"></i><%= request.getAttribute("motDePasseError") %></p>
                        <% } %>
                    </div>
                    <button type="submit" id="submitButton" class="w-full bg-gradient-to-r from-indigo-600 to-purple-600 text-white py-3 rounded-lg hover:from-indigo-700 hover:to-purple-700 transition duration-300 ease-in-out transform hover:scale-105 flex items-center justify-center">
                        <span id="spinner" class="mr-3 hidden">
                            <svg class="animate-spin h-5 w-5 text-white" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                                <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                                <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                            </svg>
                        </span>
                        <span id="buttonText">Sign In</span>
                    </button>
                </form>
            </div>
        </div>
        <!--
        <div class="text-center mt-6">
            <p class="text-white">Don't have an account? <a href="#" class="font-semibold text-white hover:text-indigo-200 transition duration-300">Create an account</a></p>
        </div>
    -->
    </div>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const loginForm = document.getElementById('loginForm');
            const submitButton = document.getElementById('submitButton');
            const spinner = document.getElementById('spinner');
            const buttonText = document.getElementById('buttonText');
            const passwordInput = document.getElementById('password');
            const togglePassword = document.getElementById('togglePassword');
            loginForm.addEventListener('submit', function() {
                submitButton.disabled = true;
                spinner.classList.remove('hidden');
                buttonText.textContent = 'Signing In...';
            });
            togglePassword.addEventListener('click', function() {
                const type = passwordInput.getAttribute('type') === 'password' ? 'text' : 'password';
                passwordInput.setAttribute('type', type);
                this.querySelector('i').classList.toggle('fa-eye');
                this.querySelector('i').classList.toggle('fa-eye-slash');
            });
        });
    </script>
</body>
</html>

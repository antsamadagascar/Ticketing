
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title><%= request.getAttribute("title") != null ? request.getAttribute("title") : "Air Ticket Dashboard" %></title>

    <!-- Styles CSS -->
    <link href="<%= request.getContextPath() %>/template/assets/css/bootstrap.min.css" rel="stylesheet"> <!-- Bootstrap -->
    <link href="<%= request.getContextPath() %>/template/assets/css/app.css" rel="stylesheet"> <!-- CSS personnalisé -->
    <link rel="stylesheet" href="<%= request.getContextPath() %>/template/assets/font-awesome/css/all.min.css"> <!-- Font Awesome -->
    <link rel="stylesheet" href="<%= request.getContextPath() %>/template/assets/css/jquery.dataTables.min.css"> <!-- DataTables -->
    <link rel="stylesheet" href="<%= request.getContextPath() %>/template/assets/css/buttons/2.3.6/css/buttons.dataTables.min.css"> <!-- DataTables Buttons -->

    <!-- Scripts JavaScript -->
    <script src="<%= request.getContextPath() %>/template/assets/js/jquery/jquery-3.6.4.min.js"></script> <!-- jQuery -->
    <script src="<%= request.getContextPath() %>/template/assets/js/bootstrap.bundle.min.js"></script> <!-- Bootstrap -->
    <script src="<%= request.getContextPath() %>/template/assets/js/chart.js"></script> <!-- Chart.js -->
    <script src="<%= request.getContextPath() %>/template/assets/js/theme.js"></script> <!-- Thème -->

    <!-- DataTables et Extensions -->
    <script src="<%= request.getContextPath() %>/template/assets/js/jquery/jquery.dataTables.min.js"></script>
    <script src="<%= request.getContextPath() %>/template/assets/js/buttons/2.3.6/dataTables.buttons.min.js"></script>
    <script src="<%= request.getContextPath() %>/template/assets/js/jszip/3.7.1/jszip.min.js"></script>
    <script src="<%= request.getContextPath() %>/template/assets/js/pdfmake/0.1.68/pdfmake.min.js"></script>
    <script src="<%= request.getContextPath() %>/template/assets/js/pdfmake/0.1.68/vfs_fonts.js"></script>
    <script src="<%= request.getContextPath() %>/template/assets/js/buttons/2.3.6/buttons.html5.min.js"></script>

<!-- Template Main CSS File -->
<link href="${pageContext.request.contextPath}/template/assets/css/tailwind.min.css" rel="stylesheet">

</head>

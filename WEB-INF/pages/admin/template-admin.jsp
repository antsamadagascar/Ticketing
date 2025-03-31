<!DOCTYPE html>
<html lang="fr">
<head>
    <jsp:include page="../../includes/head.jsp" />
</head>
<body>
    <jsp:include page="../../includes/header.jsp" />
    
    <div class="container-fluid">
        <div class="row">
            <div class="col-md-3 col-lg-2 d-md-block bg-light sidebar">
                <jsp:include page="sidebar-admin.jsp" />
            </div>
            
            <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
                <c:if test="${not empty pageContent}">
                    <jsp:include page="${pageContent}" />
                </c:if>
            </main>
        </div>
    </div>
    
    <jsp:include page="../../includes/footer.jsp" />
</body>
</html>

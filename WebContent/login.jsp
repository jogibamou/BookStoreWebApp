<%@page import="com.bookstore.controls.DBManager"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    <%@page import="com.bookstore.models.*" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix = "c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Book Store</title>

<link rel="stylesheet" type="text/css" href="semantic/dist/semantic.min.css">
<script src="semantic/dist/jquery-3.1.1.min.js"></script>
<script src="semantic/dist/semantic.min.js"></script>

 <style type="text/css">
    body {
      background-color: #DADADA;
    }
    body > .grid {
      height: 100%;
    }
    .image {
      margin-top: -100px;
    }
    .column {
      max-width: 450px;
    }
  </style>
  <script>
  $(document)
    .ready(function() {
      $('.ui.form')
        .form({
          fields: {
            email: {
              identifier  : 'username',
              rules: [
                {
                  type   : 'empty',
                  prompt : '- Please enter a username'
                }
              ]
            },
            password: {
              identifier  : 'password',
              rules: [
                {
                  type   : 'empty',
                  prompt : '- Please enter your password'
                }
              ]
            }
          }
        })
      ;
    })
  ;
  </script>
  
</head>
<body>
<%
if(session.isNew())
	out.println("Hello From the other word");
else 
	out.println("Hello From the else");
User user_logged = (User)session.getAttribute("user_logged");
%>
	<c:choose>
		<%--load the default log-in if the session is a new session  or 
			there is no user linked to that session--%>
		<c:when test="${user_logged==null}">
		<%if (user_logged!=null) out.print("user_in"); else out.print("user_out"); %> 
			<div class="ui middle aligned center aligned grid">
				<div class="column">
					<h2 class="ui teal image header">
						<div class="content">Log-in to your account</div>
					</h2>
					<form class="ui large form" method="post"
						action="${pageContext.request.contextPath}/LoginServlet">
						<div class="ui stacked segment">
							<div class="field">
								<div class="ui left icon input">
									<i class="user icon"></i> <input type="text" name="username"
										placeholder="Username">
								</div>
							</div>
							<div class="field">
								<div class="ui left icon input">
									<i class="lock icon"></i> <input type="password"
										name="password" placeholder="Password">
								</div>
							</div>
							<div class="ui fluid large teal submit button">Login</div>
						</div>

						<%-- <div class="ui error message"></div>--%>

					</form>
					<c:choose> 
						<c:when test ="${errorMessage!=null}">
							<div class="ui error message">
								<ul>
									<li>${errorMessage}</li>
								</ul>
							</div>
							</c:when>
					</c:choose>
					<div class="ui message">
						New to us? <a href="register.jsp">Sign Up</a>
					</div>
				</div>
			</div>
		</c:when>
		
		<c:when test="${user_logged!=null}">
			<%
				if(DBManager.checkUser(user_logged.getUserName(), user_logged.getPassword())){
					response.sendRedirect("home.jsp");
				}else{
					request.setAttribute("errorMessage", "No User with the credentials entered was found.");
					request.getRequestDispatcher("/login.jsp").forward(request, response);
				}
			%>
		</c:when>
	</c:choose>

</body>
</html>
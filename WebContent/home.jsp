<%@page import="com.bookstore.controls.DBManager"%>
<%@page import="com.bookstore.models.*" %>
<%@page import="java.util.LinkedList"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
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
<script type="text/javascript" src="semantic/my_javascript.js"></script>

</head>
<body>
<%!
User user_logged = null;
LinkedList<Book> books = null;
LinkedList<Book> books_in_cart = null;
int cart_elements = 0;
%>
<%
user_logged = (User)session.getAttribute("user_logged");
if(user_logged!=null){
	//user_logged = (DBManager.checkUser(user_logged.getUserName(), user_logged.getPassword()))? user_logged:null;
	//if(user_logged!=null){
		books = DBManager.getAllBooks();
		books_in_cart = DBManager.getBooksInCart(user_logged);
		cart_elements = (books_in_cart.size()!=0)?books_in_cart.size(): 0;
	//}
}
%>
<c:choose>
		<c:when test="${user_logged!=null}">
			<!-- Menu -->
			<div class="ui secondary fixed menu" style="background-color: white;">
				<a class="active item" href="home.jsp"> Home </a> <a class="item" href="user_info.jsp"> Personal Info </a> <a
					class="item" href ="order.jsp"> Orders </a>
				<div class="right menu">
					<form method="post"
						action="${pageContext.request.contextPath}/HomeServlet">
						<input type="submit" class="ui button" value="<%out.print("Cart | "+ cart_elements); %>" name = "cartButton">
					</form>
					<form method="post"
						action="${pageContext.request.contextPath}/LogoutServlet">
						<input type="submit" class="negative ui button" value="Log-out" name = "Log-out">
					</form>
				</div>
			</div>

			<!-- Body -->
			<div class="ui grid">
				<div class="three wide column"></div>
				<div class="ten wide column">
					<div class="ui link cards">
						<%
							for (Book book : books) {
						%><div class="card">
							<div class="image">
								<img src="bookImages/<%=book.getIsbn()%>.jpg">
							</div>
							<div class="content">
								<a class="header"><%=book.getTitle()%></a>
								<div class="meta">
									<span class="date">Author: <%=book.getAuthor()%></span>
								</div>
								<div class="description">
									ISBN:<%=book.getIsbn()%></br>
									 <%
									 	if (book.getQuantity() > 0)
									 		out.print("In Stock: " + book.getQuantity());
									 	else
									 		out.print("<font style = \"color:red; \" >Out of Stock</font>");
									 %>
									
									</br> Price: $<%=book.getUnitPrice()%></br>
									<%
										if (book.getEdition() == 0 || book.getEdition() == 1)
														out.println("Edition: 1 </br>");
													else
														out.println("Edition: " + book.getEdition());
									%></br>
								</div>
							</div>
							<div class="extra content">
								<form action="${pageContext.request.contextPath}/HomeServlet"
									method="post">

									<input name="book_id" value="<%=book.getId()%>" type="hidden">
									<input class="ui primary button" value="Add to cart"
										type="submit" name="addToCartButton" <% if(book.getQuantity()==0) out.print("disabled");%>>
								</form>
							</div>
						</div>
						<%	} %>
					</div>
				</div>
				<div class="three wide column"></div>
			</div>
		</c:when>
		<c:otherwise>
			<%
				response.sendRedirect("login.jsp");
			%>
		</c:otherwise>
	</c:choose>
</body>
</html>
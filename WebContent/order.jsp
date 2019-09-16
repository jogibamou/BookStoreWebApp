<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    <%@page import="java.util.LinkedList"%>
    <%@page import="com.bookstore.controls.DBManager"%>
<%@page import="com.bookstore.models.*" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix = "c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>BookStore</title>
<link rel="stylesheet" type="text/css" href="semantic/dist/semantic.min.css">
<script src="semantic/dist/jquery-3.1.1.min.js"></script>
<script src="semantic/dist/semantic.min.js"></script>
</head>
<body>
<%!
LinkedList<Order> orders_made = new LinkedList<Order>();
User user_logged = null;
%>
<%
user_logged = (User)session.getAttribute("user_logged");
if(user_logged!=null){
	orders_made = DBManager.getAllOrdersMade(user_logged);
}
%>
<c:choose>
		<c:when test="${user_logged!=null}">
<!-- Menu -->
	<div class="ui secondary fixed menu" style="background-color: white;">
		<a class="item" href="home.jsp"> Home </a>
		<a class="item" href="user_info.jsp"> Personal Info </a> <a class="active item" href="order.jsp"> Orders </a>
		<div class="right menu">
		<form method="post"
			action="${pageContext.request.contextPath}/LogoutServlet">
			<input type="submit" class="negative ui button" value="Log-out"
				name="Log-out">
		</form>
		</div>
	</div>
	<!-- End Menu -->
	<div class="ui grid">
		<div class="three wide column"></div>
		<div class="ten wide column">
			<table class="ui celled table">
			<thead>
				<tr>	
					<th>Order date</th>
					<th>Image</th>
					<th>Author</th>
					<th>Unit Price</th>
					<th>Ordered Quantity</th>
					<th>Expected Delivery</th>
				</tr>
			</thead>
			<tbody>
					<%
						for (Order order : orders_made) {
					%>
					<tr>
						<td><%=order.getDateTime() %></td>
						<td><input type="image"
							src="bookImages/<%=order.getBook().getIsbn()%>.jpg" width="100px"></td>
						<td><label><%=order.getBook().getTitle()%> by</br> <%=order.getBook().getAuthor()%></label></td>
						<td><label>$<%=order.getBook().getUnitPrice()%></label></td>
						<td><label><%=order.getBook().getQuantityOrdered() %></label></td>
						<td><label><%=order.getDeliveryDate() %></label>
					</tr>
					<%
						}
					%>
				</tbody>
				</table>
		</div>
		<div class="three wide column"></div>
	</div>
	</c:when>
	<c:otherwise>
	<% response.sendRedirect("login.jsp");%>
	</c:otherwise>
	</c:choose>
</body>
</html>
<%@page import="com.bookstore.controls.DBManager"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@page import="com.bookstore.models.*" %>
<%@page import="java.util.*" %>
<%@page import="java.util.LinkedList"%>
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
</head>
<body>
<%!
User user_logged;
LinkedList<Book> book_ordered = new LinkedList<>();
%>
<%
user_logged = (User)session.getAttribute("user_logged");
if(user_logged != null){
	book_ordered = DBManager.getBooksInCart(user_logged);
	DBManager.removeListBookFromCart(book_ordered, user_logged);
}
%>
<c:choose>
		<c:when test="${user_logged!=null}">
	<div class="ui secondary fixed menu" style="background-color: white;">
		<a class="active item" href="home.jsp"> Home </a> <a class="item"
			href="user_info.jsp"> Personal Info </a> <a class="item"> Orders
		</a>
		<div class="right menu">
			<form method="post"
				action="${pageContext.request.contextPath}/LogoutServlet">
				<input type="submit" class="negative ui button" value="Log-out"
					name="Log-out">
			</form>
		</div>
	</div>
	<div class="ui grid">
		<div class="four wide column"></div>
		<div class="ten wide column">
		<h2>Order Confirmation</h2>
		<h4>Dear <%= user_logged.getUserName() %>;</h4>
		<p>Your Order is on its way, Check your Email address for further details</p>
		<p>following is a summary of your order:</p>
		<h4 class="ui dividing header">Selected Books</h4>
		<table class="ui celled table">
			<thead>
				<tr>
					<th>Image</th>
					<th>Author</th>
					<th>Unit Price</th>
					<th>Ordered Quantity</th>
				</tr>
			</thead>
			<tbody>
					<%
						for (Book book : book_ordered) {
					%>
					<tr>
						<td><input type="image"
							src="bookImages/<%=book.getIsbn()%>.jpg" width="100px"></td>
						<td><label><%=book.getTitle()%> by</br> <%=book.getAuthor()%></label></td>
						<td><label>$<%=book.getUnitPrice()%></label></td>
						<td><label><%=book.getQuantityOrdered() %></label></td>

					</tr>
					<%
						}
					%>
				</tbody>
				<tfoot>
					<tr>
						<td><label>Total price: </label><div class="ui input"><input type="text"  name="total"
							disabled="disabled" value="<%out.print("$ "+Book.getTotalPrice(book_ordered));%>"></div></td>
					</tr>
				</tfoot>
			</table>
			<form class="ui large form">
			<div class="field">
					<label>Delivery Address</label>
					<div class="fields">
						<div class="twelve wide field">
							<input type="text" name="shipping[address]"
								placeholder="Street Address"
								value="<%if (user_logged.getAddress1() != null)
								out.print(user_logged.getAddress1());%>" disabled="disabled">
						</div>
						<div class="four wide field">
							<input type="text" name="shipping[address-2]" placeholder="Apt #"
								value="<%if (user_logged.getAddress2() != null)
								out.print(user_logged.getAddress2());%>" disabled="disabled">
						</div>
					</div>
				</div>
				<div class="three fields">
					<div class="field">
						<label>State</label> <input type="text" name="state"
							placeholder="State"
							value="<%if (user_logged.getState() != null)
								out.print(user_logged.getState());%>" disabled="disabled">
					</div>
					<div class="field">
						<label>Zip Code</label> <input type="number" maxlength="5"
							name="zip_code" placeholder="Zip Code"
							value="<%if (user_logged.getZipcode() != 0)
								out.print(user_logged.getZipcode());%>" disabled="disabled">
					</div>
					<div class="field">
						<label>Country</label> <input type="text" name="country"
							placeholder="Country"
							value="<%if (user_logged.getCountry() != null)
								out.print(user_logged.getCountry());%>" disabled="disabled">
					</div>
				</div>
				</form>
		<a href="home.jsp"><button class="ui primary button">Home</button></a>
		</div>
		
		<div class="four wide column"></div>
	</div>
	</c:when>
	<c:otherwise><%response.sendRedirect("home.jsp"); %></c:otherwise>
	</c:choose>
</body>
</html>
<%@page import="com.bookstore.controls.CartServlet"%>
<%@page import="java.util.LinkedList"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@page import="com.bookstore.controls.DBManager"%>
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
</head>


<body>
<%!
LinkedList<Book> book_ordered = new LinkedList<>();
User user_logged = null;
int size = 0;
%>
<%
user_logged = (User)session.getAttribute("user_logged");
if(user_logged!=null){
		book_ordered = DBManager.getBooksInCart(user_logged);
		size = book_ordered.size();
}
	
%>
<c:choose>
		<c:when test="${user_logged!=null}">
	<!-- Menu -->
	<div class="ui secondary fixed menu" style="background-color: white;">
		<a class="item" href="home.jsp"> Home </a>
		<a class="item" href="user_info.jsp"> Personal Info </a> <a class="item" href="order.jsp"> Orders </a>
		<div class="right menu">
		<form action="${pageContext.request.contextPath}/CartServlet" method ="post" >
			<input type="submit" name = "cancel_order" class="ui button" value = "Cancel Order" onclick="return confirm('Do You really want to cancel this order?')"
				<% if(book_ordered.size()==0) out.print("disabled");%>>
		</form>
		</div>
		<form method="post"
			action="${pageContext.request.contextPath}/LogoutServlet">
			<input type="submit" class="negative ui button" value="Log-out"
				name="Log-out">
		</form>
	</div>
	<!-- End Menu -->
	<c:set var="size" scope="session" value="<%=size%>" />
	<c:choose>
		<c:when test="${size>0 }">
			<div class="ui grid">

				<div class="three wide column"></div>
				<div class="ten wide column">
				<p style="color: red;">*To remove a book from the cart, set quantity to zero (0)</p>
					<form class="ui form" method="POST"
						action="${pageContext.request.contextPath}/CartServlet" onsubmit="return validateCheckout()">

						<!-- Configure book from cart here -->
						<h4 class="ui dividing header">Product Information</h4>
						<table class="ui celled table">
							<thead>
								<tr>
									<th>Image</th>
									<th>Author</th>
									<th>In Stock</th>
									<th>Unit Price</th>
									<th>Quantity</th>
								</tr>
							</thead>
							<tbody>
								<%for(Book book : book_ordered){ %>
								<tr>
									<td><input type="image"
										src="bookImages/<%=book.getIsbn()%>.jpg" width="100px"></td>
									<td><label><%=book.getTitle()%> by</br> <%=book.getAuthor()%></label></td>
									<td><label name="stock"><%=book.getQuantity()%></label></td>
									<td><label>$<%=book.getUnitPrice()%></label></td>

									<td><input type="number"
										name="<%out.print("quantity_"+book.getId()); %>"
										placeholder="Quantity Ordered" onkeyup="updatePrice()"
										value="<%if(book.getQuantityOrdered()!=0) out.print(book.getQuantityOrdered()); else out.print("1");%>"></td>
									<input type="hidden"
										name="<%out.print("Uprice_"+book.getId());%>"
										value="<%out.print(book.getUnitPrice());%>">
									<input type="hidden" name="book_id" value="<%=book.getId()%>">

								</tr>
								<%} %>
							</tbody>
							<tfoot>
								<tr>
									<td><input type="text" name="total" placeholder="Total"
										disabled="disabled"></td>
								</tr>
							</tfoot>
						</table>
						
						<!-- book info here -->
						<div class="ui error message"></div>
						<input type="submit" value="Checkout" name = "checkout_order"
							class="ui primary button">
					</form>
					<p style="color: red;" name="error_p">${errorMessage}</p>
				</div>
				<div class="three wide column"></div>
			</div>
			<script type="text/javascript">
			var total_price = 0;
			var ids_book = document.getElementsByName("book_id");
			for (var i = 0; i < ids_book.length; i++) {
				var quantity_str = document.getElementsByName("quantity_"+ ids_book[i].value)[0].value;
				var uprice = parseFloat(document.getElementsByName("Uprice_"+ ids_book[i].value)[0].value);
				if (quantity_str != "") {
					var quantity = parseInt(quantity_str);
					if(quantity>=0)
						total_price += uprice * quantity_str;
					else
						alert("Quantity cannot be negative");
				}
			}
			document.getElementsByName("total")[0].value = "$"+total_price;
			
						function updatePrice() {
							var total_price = 0;
							var error_para = document.getElementsByName("error_p");
							var in_stock = document.getElementsByName("stock");
							var ids_book = document.getElementsByName("book_id");
							for (var i = 0; i < ids_book.length; i++) {
								var quantity_str = document.getElementsByName("quantity_"+ ids_book[i].value)[0].value;
								var uprice = parseFloat(document.getElementsByName("Uprice_"+ ids_book[i].value)[0].value);
								if (quantity_str != "") {
									var quantity = parseInt(quantity_str);
									if(quantity>=0)
										total_price += uprice * quantity_str;
									else
										alert("Quantity cannot be negative");
									var stock = parseInt(in_stock[i].innerHTML);
									if(quantity>stock){
										error_para[0].innerHTML = "One of the quantities entered is greater than available stock";
									}else
										error_para[0].innerHTML = "";
								}
							}
							document.getElementsByName("total")[0].value = "$"+total_price;
						}
						
						function validateCheckout(){
							var error_para = document.getElementsByName("error_p");
							var in_stock = document.getElementsByName("stock");
							var ids_book = document.getElementsByName("book_id");
							for (var i = 0; i < ids_book.length; i++) {
								var quantity_str = document.getElementsByName("quantity_"+ ids_book[i].value)[0].value;
								var quantity = parseInt(quantity_str);
								var stock = parseInt(in_stock[i].innerHTML);
								if(quantity>stock){
									error_para[0].innerHTML = "One of the quantities entered is greater than available stock, please change it.";
									return false;
								}else{
									error_para[0].innerHTML = "";
									return true;
								}
							}
						}
					</script>
		</c:when>
		<c:otherwise>
			<div class="ui grid">
				<div class="four wide column"></div>
				<div class="ten wide column">
					<h1>No Items in Cart</h1>
				</div>
				<div class="four wide column"></div>
			</div>
		</c:otherwise>
	</c:choose>
	</c:when>
	<c:otherwise><%response.sendRedirect("login.jsp");%></c:otherwise>
	</c:choose>
</body>
</html>
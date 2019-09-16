<%@page import="com.bookstore.controls.DBManager"%>
<%@page import="java.util.LinkedList"%>
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
<script type="text/javascript" src="semantic/my_javascript.js"></script>
</head>
<script>
  $(document)
    .ready(function() {
      $('.ui.form')
        .form({
          fields: {
        	  quantityOrdered: {
              identifier  : 'quantityOrdered',
              rules: [
                {
                  type   : 'empty',
                  prompt : '- . Please enter a quantity'
                }
              ]
            },
            shipping_address: {
              identifier  : 'shipping[address]',
              rules: [
                {
                  type   : 'empty',
                  prompt : '- . Please enter your address'
                }
              ]
            },
            state:{
            	identifier  : 'state',
                rules: [
                  {
                    type   : 'empty',
                    prompt : '- . Please enter your State'
                  }
                ]
            },
            zip_code:{
            	identifier  : 'zip_code',
                rules: [
                  {
                    type   : 'empty',
                    prompt : '- . Please enter your Zip Code'
                  }
                ]
            },
            country:{
            	identifier  : 'country',
                rules: [
                  {
                    type   : 'empty',
                    prompt : '- . Please enter your Country'
                  }
                ]
            },
            card_number:{
            	identifier  : 'card[number]',
                rules: [
                  {
                    type   : 'empty',
                    prompt : '- .  Please enter your card number'
                  },
                  {
                      type   : 'length[16]',
                      prompt : '- .  Your card number should be 16 digits'
                    }
                ]
            },
            cvc:{
            	identifier  : 'card[cvc]',
                rules: [
                  {
                    type   : 'empty',
                    prompt : '-   Please enter your CVC number. It\'s a 3 digits number at the back of your card'
                  },
                  {
                      type   : 'length[3]',
                      prompt : '- .  Your cvc should be 3 digits'
                    }
                ]
            },
            card_exp_month:{
            	identifier  : 'card[expire-month]' ,
                rules: [
                  {
                    type   : 'empty',
                    prompt : '- .  Please enter the expiration month of your card'
                  },
                  {
                      type   : 'length[2]',
                      prompt : '- .  month is 2 digits'
                    }
                ]
            },
            card_exp_year:{
            	identifier  : 'card[expire-year]',
                rules: [
                  {
                    type   : 'empty',
                    prompt : '- .  Please enter the expiration year of your card'
                  },
                  {
                      type   : 'length[4]',
                      prompt : '- .  month is 4 digits'
                    }
                ]
            }
          }
        })
      ;
    })
  ;
  </script>
<body>
<%!
LinkedList<Book> book_ordered = new LinkedList<Book>();
User user_logged = null;
int size = 0;
%>
<%
user_logged = (User)session.getAttribute("user_logged");
if(user_logged!=null){
	book_ordered = DBManager.getBooksInCart(user_logged);
	size = book_ordered.size();
	if(size==0)
		response.sendRedirect("home.jsp");
}

%>
<c:choose>
		<c:when test="${user_logged!=null}">
	<!-- Menu -->
	<div class="ui secondary fixed menu" style="background-color: white;">
		<a class="item" href="home.jsp"> Home </a> <a class="item"
			href="user_info.jsp"> Personal Info </a> <a class="item"> Orders
		</a>
		<div class="right menu">
			<form action="${pageContext.request.contextPath}/CartServlet"
				method="post">
				<input type="submit" name="back_to_cart" class="ui button"
					value="Back to cart"
					onclick="return confirm('Do You really want to abor the check out process and back to cart?')">
			</form>
		</div>
		<form method="post"
			action="${pageContext.request.contextPath}/LogoutServlet">
			<input type="submit" class="negative ui button" value="Log-out"
				name="Log-out">
		</form>
	</div>
	<!-- End Menu -->
	<div class="ui grid">
		<div class="three wide column"></div>
		<div class="ten wide column">
		<p style="color: red;">*All changes to address and credit/debit
						card will directly affect the data stored in the system.</p>
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
			
			<form class="ui form" name="checkout_form" method ="post" action="${pageContext.request.contextPath}/CheckoutServlet" onsubmit="return validateCheckoutForm();">
				<h4 class="ui dividing header">Shipping Information</h4>
				<div class="field">
					<label>Name</label>
					<div class="field">
						<input type="text" name="name" placeholder="Name"
							value="<%=user_logged.getName()%> " disabled="disabled">
					</div>
				</div>
				<div class="field">
					<label>Contact info</label>
					<div class="fields">
						<div class="eight wide field">
							<input type="text" name="phoneNumber" placeholder="Phone Number"
								value="<%=user_logged.getPhoneNumber()%>" disabled="disabled">
						</div>
						<div class="eight wide field">
							<input type="text" name="eMail" placeholder="E-mail"
								value="<%=user_logged.getEmail()%>" disabled="disabled">
						</div>
					</div>
				</div>
				<div class="field">
					<label>Billing Address*</label>
					<div class="fields">
						<div class="twelve wide field">
							<input type="text" name="shipping[address]"
								placeholder="Street Address"
								value="<%if (user_logged.getAddress1() != null)
								out.print(user_logged.getAddress1());%>">
						</div>
						<div class="four wide field">
							<input type="text" name="shipping[address-2]" placeholder="Apt #"
								value="<%if (user_logged.getAddress2() != null)
								out.print(user_logged.getAddress2());%>">
						</div>
					</div>
				</div>
				<div class="three fields">
					<div class="field">
						<label>State*</label> <input type="text" name="state"
							placeholder="State"
							value="<%if (user_logged.getState() != null)
								out.print(user_logged.getState());%>">
					</div>
					<div class="field">
						<label>Zip Code*</label> <input type="number" maxlength="5"
							name="zip_code" placeholder="Zip Code"
							value="<%if (user_logged.getZipcode() != 0)
								out.print(user_logged.getZipcode());%>">
					</div>
					<div class="field">
						<label>Country*</label> <input type="text" name="country"
							placeholder="Country"
							value="<%if (user_logged.getCountry() != null)
								out.print(user_logged.getCountry());%>">
					</div>
				</div>
				<h4 class="ui dividing header">Billing Information</h4>
				<div class="fields">
					<div class="seven wide field">
						<label>Card Number*</label> <input type="number"
							name="card[number]" maxlength="16" placeholder="Card #"
							value="<%if (user_logged.getCardNumber() != 0)
								out.print(user_logged.getCardNumber());%>">
					</div>
					<div class="three wide field">
						<label>CVC*</label> <input type="password" name="card[cvc]"
							maxlength="3" placeholder="CVC" value="">
					</div>
					<div class="six wide field">
						<label>Expiration*</label>
						<div class="two fields">
							<div class="field">
								<input type="number" name="card[expire-month]"
									value="<%if (user_logged.getCardExpirationMonth() != 0)
								out.print(user_logged.getCardExpirationMonth());%>"
									placeholder="Month" maxlength="2">
							</div>
							/
							<div class="field">
								<input type="number" name="card[expire-year]" maxlength="4"
									placeholder="Year"
									value="<%if (user_logged.getCardExpirationYear() != 0)
								out.print(user_logged.getCardExpirationYear());%>">
							</div>
						</div>
					</div>
				</div>
				<input type="submit" value="Submit Order" name = "submit_order"
							class="ui primary button">
				<div class="ui error message"></div>
			</form>
			<div class="ui error message" id="error_block"></div>
		</div>
		<div class="three wide column"></div>
		
	</div>
	<script type="text/javascript">
	function validateCheckoutForm(){
		var success = true;
		var regex_name = /^[a-zA-Z]+(([',. -][a-zA-Z ])?[a-zA-Z]*)*$/;
		var regex_name_number = /^[a-z0-9A-Z]+(([',. -][a-z0-9A-Z ])?[a-z0-9A-Z]*)*$/;
		var regex_csv = /^[0-9]*$/;
		
		var street_value = document.forms["checkout_form"]["shipping[address]"].value;
		var apt_value = document.forms["checkout_form"]["shipping[address-2]"].value;
		var state_value = document.forms["checkout_form"]["state"].value;
		var country_value = document.forms["checkout_form"]["country"].value;
		var csv_value = document.forms["checkout_form"]["card[cvc]"].value;
		var div_error = document.getElementById("error_block");
		
		//empty element of the div tag
		while (div_error.firstChild) {
			div_error.removeChild(div_error.firstChild);
		}
		
		if(!regex_name_number.test(street_value)){
			var list = document.createElement("ul");
			var element_list_1 = document.createElement("li");
			var node_1 = document.createTextNode("Billing info address 1 format incorrect");
			element_list_1.appendChild(node_1);
			list.appendChild(element_list_1);
			div_error.appendChild(list);
			success = false;
		}
		
		if(!regex_name_number.test(apt_value)){
			var list = document.createElement("ul");
			var element_list_1 = document.createElement("li");
			var node_1 = document.createTextNode("Billing info address 2 format incorrect");
			element_list_1.appendChild(node_1);
			list.appendChild(element_list_1);
			div_error.appendChild(list);
			success = false;
		}
		if(!regex_name.test(country_value)){
			var list = document.createElement("ul");
			var element_list_1 = document.createElement("li");
			var node_1 = document.createTextNode("country format incorrect");
			element_list_1.appendChild(node_1);
			list.appendChild(element_list_1);
			div_error.appendChild(list);
			success = false;
		}
		if(!regex_name.test(state_value)){
			var list = document.createElement("ul");
			var element_list_1 = document.createElement("li");
			var node_1 = document.createTextNode("state format incorrect");
			element_list_1.appendChild(node_1);
			list.appendChild(element_list_1);
			div_error.appendChild(list);
			success = false;
		}
		if(!regex_csv.test(csv_value)){
			var list = document.createElement("ul");
			var element_list_1 = document.createElement("li");
			var node_1 = document.createTextNode("csv format incorrect");
			element_list_1.appendChild(node_1);
			list.appendChild(element_list_1);
			div_error.appendChild(list);
			success = false;
		}
		
		
		return success;
	}
</script>
</c:when>
<c:otherwise><%response.sendRedirect("home.jsp"); %></c:otherwise>
</c:choose>
</body>
</html>
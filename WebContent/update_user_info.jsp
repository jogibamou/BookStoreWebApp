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

<script>
  $(document)
    .ready(function() {
      $('.ui.form')
        .form({
          fields: {
        	  username: {
                  identifier  : 'username',
                  rules: [
                    {
                      type   : 'empty',
                      prompt : '- Please enter your username'
                    }
                  ]
                },
                name: {
                    identifier  : 'name',
                    rules: [
                      {
                        type   : 'empty',
                        prompt : '- Please enter your name'
                      }
                    ]
                  },
                  phoneNumber: {
                      identifier  : 'phoneNumber',
                      rules: [
                        {
                          type   : 'empty',
                          prompt : '- Please enter your phone number'
                        }
                      ]
                    },
            email: {
              identifier  : 'eMail',
              rules: [
                {
                  type   : 'empty',
                  prompt : '- Please enter your e-mail'
                },
                {
                  type   : 'email',
                  prompt : '- Please enter a valid e-mail'
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

</head>
<%!
User user_logged = null; 
%>
<%
user_logged = (User)session.getAttribute("user_logged");
if(user_logged == null)
	response.sendRedirect("login.jsp");
%>
<body>
<c:choose>
		<c:when test="${user_logged!=null}">
<!-- Menu -->
			<div class="ui secondary fixed menu" style="background-color: white;">
				<a class="item" href="home.jsp"> Home </a> <a class="active item" href="user_info.jsp"> Personal Info </a> <a
					class="item"> Orders </a>
				<div class="right menu">
					<form method="post"
						action="${pageContext.request.contextPath}/LogoutServlet">
						<input type="submit" class="negative ui button" value="Log-out" name = "Log-out">
					</form>
				</div>
			</div>
	<!--End Menu -->
	<div class="ui grid">
		<div class="three wide column"></div>
		<div class="ten wide column">
			<!-- Body -->
			<p style="color: red;">*Required Info.</p>
			<form class="ui form" method ="post" action="${pageContext.request.contextPath}/UpdateInfoServlet" onsubmit="return validateRegistrationForm()">
			<h4 class="ui dividing header">Contact Information</h4>
				<div class="field">
					<label>Name*</label>
					<div class="field">
						<input type="text" name="name" placeholder="Name"
							value="<%=user_logged.getName()%> ">
					</div>
				</div>
				<div class="field">
					<label>Contact info*</label>
					<div class="fields">
						<div class="eight wide field">
							<input type="text" name="phoneNumber" placeholder="Phone Number"
								value="<%=user_logged.getPhoneNumber()%>">
						</div>
						<div class="eight wide field">
							<input type="text" name="eMail" placeholder="E-mail"
								value="<%=user_logged.getEmail()%>">
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
								out.print(user_logged.getState());%>" >
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
				<h4 class="ui dividing header">Card Information</h4>
				<div class="fields">
					<div class="seven wide field">
						<label>Card Number*</label> <input type="number"
							name="card[number]" maxlength="16" placeholder="Card #"
							value="<%if (user_logged.getCardNumber() != 0)
								out.print(user_logged.getCardNumber());%>" >
					</div>
					<div class="six wide field">
						<label>Expiration*</label>
						<div class="two fields">
							<div class="field">
								<input type="number" name="card[expire-month]"
									value="<%if (user_logged.getCardExpirationMonth() != 0)
								out.print(user_logged.getCardExpirationMonth());%>"
									placeholder="Month" maxlength="2" >
							</div>
							/
							<div class="field">
								<input type="number" name="card[expire-year]" maxlength="4"
									placeholder="Year"
									value="<%if (user_logged.getCardExpirationYear() != 0)
								out.print(user_logged.getCardExpirationYear());%>" >
							</div>
						</div>
					</div>
				</div>
				<input class="ui primary button" value="Save" type = "submit" name = "submit-change"> 
				<a href="user_info.jsp"><button class="ui button" onclick="return confirm('Do You want to cancel the modification?')">Cancel</button></a>
				<div class="ui error message"></div>
				</form>
				
			<!-- End Body -->
		</div>
		<div class="three wide column"></div>
	</div>
	</c:when>
	<c:otherwise><%response.sendRedirect("home.jsp"); %></c:otherwise>
	</c:choose>
</body>
</html>
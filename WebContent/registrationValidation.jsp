<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
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
	<div class="ui grid">
		<div class="four wide column"></div>
		<div class="eight wide column">
			<div class="ui card">
				<div class="content">
					<div class="header">Hi ${username}, welcome to BookStore</div>
				</div>
				<div class="content">
					Your account was created. Please go back to Log-in and log in to your account.
				</div>
				<div class="extra content">
					<a href = "login.jsp"><button class="ui button">Log-in</button></a>
				</div>
			</div>
		</div>
		<div class="four wide column"></div>
	</div>
</body>
</html>
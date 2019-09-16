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
                      identifier  : 'phone_number',
                      rules: [
                        {
                          type   : 'empty',
                          prompt : '- Please enter your phone number'
                        }
                      ]
                    },
            email: {
              identifier  : 'email',
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
            password: {
              identifier  : 'password',
              rules: [
                {
                  type   : 'empty',
                  prompt : '- Please enter your password'
                },
                {
                  type   : 'length[8]',
                  prompt : '- Your password must be at least 8 characters'
                }
              ]
            }
          }
        })
      ;
    })
  ;
  </script>
  <script type="text/javascript" src="semantic/my_javascript.js"></script>
</head>
<body>
	<div class="ui three column doubling stackable grid container">
		<div class="five wide column"></div>
		<div class="six wide column">
			<h2 class="ui teal image header">
				<div class="content">Create an account</div>
			</h2>
			
			<form name="reg_form" class="ui large form" method="post" action="${pageContext.request.contextPath}/RegisterServlet" onsubmit="return validateRegistrationForm()">
				<div class="ui stacked segment">
				<h4 class="ui dividing header">User Information</h4>
					<div class="field">
					<label>UserName</label>
						<input type="text" name="username" placeholder="UserName" value = "${username}">
					</div>
					<div class="field">
					<label>Name</label>
						<input type="text" name="name" placeholder="Name" value = "${name}">
					</div>
					<div class="field">
					<label>E-mail</label>
						<input type="text" name="email" placeholder="E-mail" value = "${e_mail}">
					</div>
					<div class="field">
					<label>Phone Number</label>
						<input type="text" name="phoneNumber" placeholder="Phone Number" value ="${phone_number}">
					</div>
					<div class="field">
					<label>Password</label>
						<input type="password" name="password" placeholder="Password">
					</div>
					<div class="field">
					<label>Confirm Password</label>
						<input type="password" name="re_password" placeholder="Password">
					</div>
					<div class="ui fluid large teal submit button">Create</div>
				</div>

				<div class="ui error message"></div>

			</form>
			<div class="ui error message" id="error_block">
			${errorMessageUserName }</br>
			${errorMessagePhoneNumber}
			</div>
			<div class="ui message">
				Already have an account? <a href="login.jsp">Log in</a>
			</div>
		</div>
		<div class="five wide column"></div>
	</div>
</body>
</html>
package com.bookstore.controls;

import java.io.IOException;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.bookstore.models.User;

/**
 * Servlet implementation class RegisterServelt
 */
@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public RegisterServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.sendRedirect("404.jsp");
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String name = request.getParameter("name");
		String eMail = request.getParameter("email");
		String phoneNumber = request.getParameter("phoneNumber");
		String userName = request.getParameter("username");
		String password = request.getParameter("password");
		String rePassword = request.getParameter("re_password");
		try {
			if(DBManager.isUserNameAvailable(userName)) {
				request.setAttribute("errorMessageUserName", "UserName already taken, please try another one.");
				reFillArguments(request, name, eMail, phoneNumber, userName,response);
			}
			else if(!(isPhoneNumberValid(phoneNumber))) {
				request.setAttribute("errorMessagePhoneNumber", "Please enter a valid phone number ( - , / and space are not authorized)");
				reFillArguments(request, name, eMail, phoneNumber, userName,response);
			}
			else if(!(password.equals(rePassword))) {
				request.setAttribute("errorMessagePassword", "Password do not match");
				reFillArguments(request, name, eMail, phoneNumber, userName,response);
			}
			else {
				User user = new User(userName, name, phoneNumber, eMail, password);
				DBManager.createUser(user);
				request.setAttribute("username", userName);
				request.getRequestDispatcher("/registrationValidation.jsp").forward(request, response);
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	private static boolean isPhoneNumberValid(String phoneNumber) {
		if (phoneNumber == null)
			return false;
		else if (phoneNumber.startsWith("+")) {
			String phone = phoneNumber.substring(1);
			try {
				Long.parseLong(phone);
				return true;
			}catch(NumberFormatException ex) {
				return false;
			}
		}else {
			try {
				Long.parseLong(phoneNumber);
				return true;
			}catch(NumberFormatException ex) {
				return false;
			}
		}		
	}
	
	private static void reFillArguments(HttpServletRequest request, String name,String eMail, 
			String phoneNumber, String userName, HttpServletResponse response) throws ServletException, IOException {
		request.setAttribute("name", name);
		request.setAttribute("e_mail", eMail);
		request.setAttribute("phone_number", phoneNumber);
		request.setAttribute("username", userName);
		request.getRequestDispatcher("/register.jsp").forward(request, response);
	}
}

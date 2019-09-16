package com.bookstore.controls;

import java.io.IOException;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.Calendar;
import java.util.Date;
import java.util.LinkedList;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.bookstore.models.Book;
import com.bookstore.models.Order;
import com.bookstore.models.User;

/**
 * Servlet implementation class CheckoutServlet
 */
@WebServlet("/CheckoutServlet")
public class CheckoutServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public CheckoutServlet() {
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
		// TODO Auto-generated method stub
		User user_looged = (User)request.getSession().getAttribute("user_logged");
		if(user_looged!=null) {
			try {
				LinkedList<Book> book_ordered = DBManager.getBooksInCart(user_looged);
				Timestamp date_order = new Timestamp(System.currentTimeMillis());
				String address1 = request.getParameter("shipping[address]");
				String address2 = request.getParameter("shipping[address-2]");
				String state = request.getParameter("state");
				String country = request.getParameter("country");
				int zipCode = Integer.parseInt(request.getParameter("zip_code"));
				long cardNumber = Long.parseLong(request.getParameter("card[number]"));
				int csv = Integer.parseInt(request.getParameter("card[cvc]"));
				int cardExpYear = Integer.parseInt(request.getParameter("card[expire-year]"));
				int cardExpMonth = Integer.parseInt(request.getParameter("card[expire-month]"));
				
				setUserAddressAndCard(address1, address2, zipCode, state, country, cardNumber, cardExpMonth, cardExpYear, user_looged);
				
				DBManager.updateUserInfoAtCheckout(user_looged);
				request.getSession().setAttribute("user_logged",
						DBManager.getUserByUserName(user_looged.getUserName()));
				user_looged = (User)request.getSession().getAttribute("user_logged");
				for(Book book: book_ordered) {
					Order order = new Order(date_order,user_looged,book,incrementDate());
					DBManager.registerOrder(order);
				}
				
				Email.sendEmail(book_ordered, user_looged, incrementDate());
				response.sendRedirect("confirmationPage.jsp");
			}catch(SQLException e) {
				e.printStackTrace();
			}
		}else {
			response.sendRedirect("home.jsp");
		}
	}
	
	private void setUserAddressAndCard(String address1, String address2, int zip_code, String state, String
			country, long cardNumber,int month, int year, User user) {
		user.setAddress1(address1);
		user.setAddress2(address2);
		user.setState(state);
		user.setCountry(country);
		user.setZipcode(zip_code);
		user.setCardNumber(cardNumber);
		user.setCardExpirationMonth(month);
		user.setCardExpirationYear(year);
	}
	
	private Date incrementDate() {
		Date currentDate = new Date();
		
        // convert date to calendar
        Calendar c = Calendar.getInstance();
        c.setTime(currentDate);

        // manipulate date
        c.add(Calendar.DATE, 4); //same with c.add(Calendar.DAY_OF_MONTH, 1);

        // convert calendar to date
        Date currentDatePlusfour = c.getTime();
        return currentDatePlusfour;
	}
	/*request.getSession().setAttribute("user_logged",
			DBManager.getUserByUserName(user_logged.getUserName()));*/

}

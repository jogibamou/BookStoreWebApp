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
 * Servlet implementation class CartServlet
 */
@WebServlet("/CartServlet")
public class CartServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public CartServlet() {
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
		User user_logged = (User)request.getSession().getAttribute("user_logged");
		if(user_logged!=null) {
			if (request.getParameter("cancel_order") != null) {
				try {
					LinkedList<Book> cartBook = DBManager.getBooksInCart(user_logged);
					for(Book book:cartBook) {
						DBManager.removeBookFromCart(user_logged, book);
					}
				} catch (SQLException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				response.sendRedirect("home.jsp");
			}
			else if(request.getParameter("checkout_order") != null) {
				try {
					String[] ids_book = request.getParameterValues("book_id");
					for (int i = 0; i < ids_book.length; i++) {
						Book book = DBManager.getBookById(Integer.parseInt(ids_book[i]));
						int quantity = Integer.parseInt(request.getParameter("quantity_" + ids_book[i]));
						// Email.sendEmail(order);
						if(quantity == 0)
							DBManager.removeBookFromCart(user_logged, book);
						else
							DBManager.addBookQuantityCart(user_logged, book,quantity);
					}
					response.sendRedirect("checkout.jsp");
	
				} catch (NumberFormatException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				} catch (Exception e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}else if(request.getParameter("back_to_cart")!=null) {
				response.sendRedirect("cart.jsp");
			}
		}else {
			response.sendRedirect("login.jsp");
		}
		
	}
	
	
	
	

}

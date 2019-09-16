package com.bookstore.controls;

import java.io.IOException;
import java.sql.SQLException;

import javax.mail.Session;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.bookstore.models.Book;
import com.bookstore.models.User;
import com.sun.media.sound.RealTimeSequencerProvider;

/**
 * Servlet implementation class CartServlet
 */
@WebServlet("/HomeServlet")
public class HomeServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public HomeServlet() {
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
		User user_logged = (User)request.getSession().getAttribute("user_logged");
		if(user_logged!=null) {
			try {
				if (request.getParameter("cartButton") != null) {
					
					response.sendRedirect("cart.jsp");
				}
				else if (request.getParameter("addToCartButton") != null) {
					Book book = DBManager.getBookById(Integer.parseInt(request.getParameter("book_id")));
					if(!(DBManager.isBookInCart(user_logged, book))) {
						DBManager.addBookInCart(user_logged, book);
					}
					response.sendRedirect("home.jsp");
				}
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			
		}else {
			response.sendRedirect("login.jsp");
		}
	}

}

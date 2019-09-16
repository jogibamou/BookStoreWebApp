package com.bookstore.controls;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Date;
import java.util.LinkedList;

import javax.naming.NamingException;

import com.bookstore.models.Book;
import com.bookstore.models.Order;
import com.bookstore.models.User;

public class DBManager {
	
	private static final String SECRET_KEY_PASSWORD = "VfGm7DRIvVTyIKDMrmP8";
	private static final String SECRET_KEY_EMAIL = "B9eVgbkCZ34w4uXHBm9q";
	private static final String SECRET_KEY_CARD = "9AAZRJkbHqU42t3hb8Tu";
	
	//method to create a user inside the database.
	public static void createUser(User user) throws SQLException {
		String sql = "insert into user (username,name,phoneNumber,email,password) "
				+ "values (?,?,?,AES_ENCRYPT(?,?),AES_ENCRYPT(SHA2(?,256),?));";
		
		Connection conn = Connector.getConnection();
		PreparedStatement prepStatement = conn.prepareStatement(sql);
		prepStatement.setString(1,user.getUserName());
		prepStatement.setString(2, user.getName());
		prepStatement.setString(3, user.getPhoneNumber());
		prepStatement.setString(4, user.getEmail());
		prepStatement.setString(5, SECRET_KEY_EMAIL);
		prepStatement.setString(6, user.getPassword());
		prepStatement.setString(7, SECRET_KEY_PASSWORD);
		prepStatement.executeUpdate();
		
		prepStatement.close();
		conn.close();
	}
	
	/**
	 * return user from db using username. 
	 * @param username
	 * @return
	 * @throws SQLException
	 */
	public static User getUserByUserName(String username) throws SQLException {
		String sql = "Select iduser, username, name, phoneNumber, AES_DECRYPT(email,?), address1,"
				+ "address2, state, country, zip_code, AES_DECRYPT(card_number,?), AES_DECRYPT(card_expiration_year,?), AES_DECRYPT(card_expiration_month,?) from user where username = ?;";
		User user = new User();
		
		Connection conn = Connector.getConnection();
		PreparedStatement prepStatement = conn.prepareStatement(sql);
		prepStatement.setString(1, SECRET_KEY_EMAIL);
		prepStatement.setString(2, SECRET_KEY_CARD);
		prepStatement.setString(3, SECRET_KEY_CARD);
		prepStatement.setString(4, SECRET_KEY_CARD);
		prepStatement.setString(5,username);
		ResultSet resultSet = prepStatement.executeQuery();
		resultSet.next();
		
		user.setId(resultSet.getInt(1));
		user.setUserName(resultSet.getString(2));
		user.setName(resultSet.getString(3));
		user.setPhoneNumber(resultSet.getString(4));
		user.setEmail(resultSet.getString(5));
		//user.setPassword(resultSet.getString(6));
		user.setAddress1(resultSet.getString(6));
		user.setAddress2(resultSet.getString(7));
		user.setState(resultSet.getString(8));
		user.setCountry(resultSet.getString(9));
		user.setZipcode(resultSet.getInt(10));
		user.setCardNumber(resultSet.getLong(11));
		user.setCardExpirationYear(resultSet.getInt(12));
		user.setCardExpirationMonth(resultSet.getInt(13));
		
		prepStatement.close();
		resultSet.close();
		conn.close();
		return user;
	}
	
	/**
	 * check if user present in db. 
	 * @param username
	 * @param password
	 * @return
	 * @throws SQLException
	 * @throws NamingException
	 */
	public static boolean checkUser(String username, String password) throws SQLException, NamingException {
		String sql = "select username from user where (username= ? and password = AES_ENCRYPT(SHA2(?,256),?))";
		
		Connection conn = Connector.getConnection();
		PreparedStatement prepStatement = conn.prepareStatement(sql);
		prepStatement.setString(1, username);
		prepStatement.setString(2, password);
		prepStatement.setString(3, SECRET_KEY_PASSWORD);
		ResultSet resultSet = prepStatement.executeQuery();
		if(resultSet.next()) {
			prepStatement.close();
			resultSet.close();
			conn.close();
			return true;
		}
		else {
			prepStatement.close();
			resultSet.close();
			conn.close();
			return false;
		}
	}
	
	/**
	 * calculate the mysql sha_256 of a string
	 * @param string
	 * @return
	 * @throws SQLException
	 */
	public static String sha_string(String string) throws SQLException {
		String sql = "SELECT SHA2(?,256)";
		
		Connection conn = Connector.getConnection();
		PreparedStatement preparedStatement = conn.prepareStatement(sql);
		preparedStatement.setString(1, string);
		
		ResultSet resultSet = preparedStatement.executeQuery();
		if(resultSet.next()) {
			return resultSet.getString(1);
		}else
			return "";
	}
	
	/**
	 * return all books stored in database
	 * @return
	 * @throws SQLException
	 */
	public static LinkedList<Book> getAllBooks() throws  SQLException{
		String sql = "Select * from book;";
		LinkedList<Book> store = new LinkedList<>();
		
		Connection conn = Connector.getConnection();
		PreparedStatement prepStatement = conn.prepareStatement(sql);
		ResultSet result = prepStatement.executeQuery();
		while (result.next()) {
			Book book = new Book(result.getString(2), result.getString(3), result.getInt(4), 
					result.getDouble(5), result.getLong(6));
			book.setId(result.getInt(1));
			book.setEdition(result.getInt(7));
			
			store.add(book);
		}
		
		prepStatement.close();
		result.close();
		conn.close();
		return store;
	}
	
	public static Book getBookById(int id) throws SQLException {
		String sql = "select * from book where idbook = ?;";
		
		Connection conn = Connector.getConnection();
		PreparedStatement preparedStatement = conn.prepareStatement(sql);
		preparedStatement.setInt(1, id);
		ResultSet resultSet = preparedStatement.executeQuery();
		resultSet.next();
		
		Book book = new Book(resultSet.getString(2), resultSet.getString(3), resultSet.getInt(4), resultSet.getDouble(5), resultSet.getLong(6));
		book.setId(id);
		book.setEdition(resultSet.getInt(7));
		
		preparedStatement.close();
		resultSet.close();
		conn.close();
		
		return book;
	}
	
	public static boolean isUserNameAvailable(String username) throws SQLException {
		String sql = "select * from user where username = ?;";
		
		Connection conn = Connector.getConnection();
		PreparedStatement preparedStatement = conn.prepareStatement(sql);
		preparedStatement.setString(1, username);
		ResultSet resultSet = preparedStatement.executeQuery();
		boolean b = resultSet.next();
		
		resultSet.close();
		preparedStatement.close();
		conn.close();
		
		return b;
	}
	
	public static void registerOrder(Order order) throws SQLException {
		String sqlOrder = "insert into `order` (book_id, user_id, date, quantity_bought, expected_delivery)"
				+ "values(?,?,?,?,?)";
		String sqlUpdateBookQt = "update book set quantity = ?-? where idBook = ?;";
		
		Connection conn = Connector.getConnection();
		PreparedStatement preparedStatement_1 = conn.prepareStatement(sqlOrder);
		preparedStatement_1.setInt(1, order.getBook().getId());
		preparedStatement_1.setInt(2, order.getUser().getId());
		preparedStatement_1.setInt(4, order.getBook().getQuantityOrdered());
		preparedStatement_1.setTimestamp(3, order.getDateTime());
		preparedStatement_1.setDate(5, order.getSQLDeliveryDate());
		
		preparedStatement_1.executeUpdate();
		preparedStatement_1.close();
		
		PreparedStatement preparedStatement_2 = conn.prepareStatement(sqlUpdateBookQt);
		preparedStatement_2.setInt(1, order.getBook().getQuantity());
		preparedStatement_2.setInt(2, order.getBook().getQuantityOrdered());
		preparedStatement_2.setInt(3, order.getBook().getId());
		
		preparedStatement_2.executeUpdate();
		preparedStatement_2.close();
		conn.close();
	}
	
	public static LinkedList<Order> getAllOrdersMade(User user_logged) throws SQLException{
		LinkedList<Order> orders_made = new LinkedList<>();
		
		String sql = "select * from `order` where user_id = ?";
		Connection conn = Connector.getConnection();
		PreparedStatement preparedStatement = conn.prepareStatement(sql);
		preparedStatement.setInt(1, user_logged.getId());
		ResultSet resultSet = preparedStatement.executeQuery();
		while(resultSet.next()) {
			Book book = DBManager.getBookById(resultSet.getInt(1));
			book.setQuantityOrdered(resultSet.getInt(4));
			java.sql.Date sdeliveryDate = resultSet.getDate(5);
			java.util.Date deliveryDate = new Date(sdeliveryDate.getTime()); 
			Order order = new Order(resultSet.getTimestamp(3),user_logged,book,deliveryDate);
			orders_made.add(order);
		}
		resultSet.close();
		preparedStatement.close();
		conn.close();
		return orders_made;
	}
	
	/**
	 * update the user info from the checkout page.
	 * @param user
	 * @throws SQLException
	 */
	public static void updateUserInfoAtCheckout(User user) throws SQLException {
		String sql = "update user set address1 = ?, address2 = ?, state = ?, country = ?, "
				+ "zip_code = ?, card_number = AES_ENCRYPT(?,?), card_expiration_year = AES_ENCRYPT(?,?), card_expiration_month = AES_ENCRYPT(?,?) where iduser = ?;";
		
		Connection conn = Connector.getConnection();
		PreparedStatement prepStatement = conn.prepareStatement(sql);
		prepStatement.setString(1, user.getAddress1());
		prepStatement.setString(2, user.getAddress2());
		prepStatement.setString(3, user.getState());
		prepStatement.setString(4, user.getCountry());
		prepStatement.setInt(5, user.getZipcode());
		prepStatement.setLong(6, user.getCardNumber());
		prepStatement.setString(7, SECRET_KEY_CARD);
		prepStatement.setInt(8, user.getCardExpirationYear());
		prepStatement.setString(9, SECRET_KEY_CARD);
		prepStatement.setInt(10, user.getCardExpirationMonth());
		prepStatement.setString(11, SECRET_KEY_CARD);
		prepStatement.setInt(12, user.getId());
		
		prepStatement.executeUpdate();
		
		prepStatement.close();
		conn.close();
		
	}
	
	public static int getNumberOfElementInCart(User user) throws SQLException {
		String sql = "select * from cart where id_user = ?;";
		
		Connection conn = Connector.getConnection();
		PreparedStatement preparedStatement = conn.prepareStatement(sql);
		preparedStatement.setInt(1, user.getId());
		ResultSet result = preparedStatement.executeQuery();
		int count = 0;
		while (result.next()) {
			count++;
		}
		preparedStatement.close();
		result.close();
		conn.close();
		return count;
	}
	
	public static LinkedList<Book> getBooksInCart(User user) throws SQLException{
		LinkedList<Book> store = new LinkedList<>();
		String sql = "select id_book, quantity from cart where id_user = ?;";
		
		Connection conn = Connector.getConnection();
		PreparedStatement prepStatement = conn.prepareStatement(sql);
		prepStatement.setInt(1, user.getId());;
		ResultSet resultSet = prepStatement.executeQuery();
		while(resultSet.next()) {
			Book book = getBookById(resultSet.getInt(1));
			int quantity = resultSet.getInt(2);
			book.setQuantityOrdered(quantity);
			store.add(book);
		}
		//System.out.print("Get_Book");
		prepStatement.close();
		resultSet.close();
		conn.close();
		return store;
	}
	
	public static boolean isBookInCart(User user, Book book) throws SQLException {
		String sql = "select * from cart where id_user = ? and id_book = ?;";
		
		Connection conn = Connector.getConnection();
		PreparedStatement prepStatement = conn.prepareStatement(sql);
		prepStatement.setInt(1, user.getId());
		prepStatement.setInt(2, book.getId());
		ResultSet resultSet = prepStatement.executeQuery();
		boolean isInCart = resultSet.next();
		
		resultSet.close();
		prepStatement.close();
		conn.close();
		return isInCart;
	}
	
	public static void removeBookFromCart(User user, Book book) throws SQLException {
		String sql = "delete from cart where id_book=? and id_user=?;";
		
		Connection conn = Connector.getConnection();
		PreparedStatement preparedStatement = conn.prepareStatement(sql);
		preparedStatement.setInt(1, book.getId());
		preparedStatement.setInt(2, user.getId());
		preparedStatement.executeUpdate();
		
		preparedStatement.close();
		conn.close();
	}
	
	public static void removeListBookFromCart(LinkedList<Book> book_ordered, User user) {
		for(Book book:book_ordered) {
			try {
				removeBookFromCart(user, book);
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
	}
	
	public static void addBookInCart(User user, Book book) throws SQLException {
		String sql = "Insert into cart (id_user, id_book) values(?,?);";
		
		Connection conn = Connector.getConnection();
		PreparedStatement prepStatement = conn.prepareStatement(sql);
		prepStatement.setInt(1, user.getId());
		prepStatement.setInt(2, book.getId());
		prepStatement.executeUpdate();
		
		prepStatement.close();
		conn.close();
	}
	
	public static void addBookQuantityCart(User user, Book book, int quantity) throws SQLException {
		String sql = "update cart set quantity = ? where id_book=? and id_user=?;";
		
		Connection conn = Connector.getConnection();
		PreparedStatement preparedStatement = conn.prepareStatement(sql);
		preparedStatement.setInt(1, quantity);
		preparedStatement.setInt(2, book.getId());
		preparedStatement.setInt(3, user.getId());
		preparedStatement.executeUpdate();
		
		preparedStatement.close();
		conn.close();
	}
	
}

package com.bookstore.controls;

import java.util.*;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;

import com.bookstore.models.*;

import javax.mail.*;
import javax.mail.internet.*;

/**
 * Servlet implementation class Email
 */
@WebServlet("/Email")
public class Email extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    private static final String userName = "donotreply.javbookstore@gmail.com";
    private static final String password = "SsTyB35_9Kk01";
    public Email() {
        super();
        // TODO Auto-generated constructor stub
    }
    
    @SuppressWarnings("deprecation")
	public static void sendEmail(LinkedList<Book> book_ordered, User user, Date date) {
    	Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");

        Session session = Session.getInstance(props,
          new javax.mail.Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(userName, password);
            }
          });

        try {
        	String toAddress = user.getEmail();
            Message msg = new MimeMessage(session);
            msg.setFrom(new InternetAddress(userName));
            msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toAddress));
            String subject = "Thank You For Your Purchase!";
            int month = date.getMonth();
            int day = date.getDate();
            int year = date.getYear()-100;
            String test = month +  "/" + day + "/" + year;
    		String message = "Dear "+user.getUserName()+",\nThe following is a copy of your reciept from your latest purchase.\n";
    		for (Book book:book_ordered) {
    			message+="- "+book.getTitle()+" by "+book.getAuthor()+": "+book.getQuantityOrdered()+" smaple(s) at $"+book.getUnitPrice()+" each\n";
    		}
    		message+="Total price paid: $"+Book.getTotalPrice(book_ordered)+"\n";
            message+="\nExpected Delivery Date: "+test;
    		msg.setSentDate(new Date());
			msg.setText(message);
			msg.setSubject(subject);
			
            Transport.send(msg);

            System.out.println("Done");

        } catch (MessagingException e) {
            e.printStackTrace();
        }
    }

}

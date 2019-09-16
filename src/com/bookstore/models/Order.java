package com.bookstore.models;

import java.sql.Timestamp;
import java.util.Date;

public class Order {
	private Timestamp dateTime;
	private User user;
	private Book book;
	private int quantityOrdered;
	private Date deliveryDate;

	public Order() {}

	public Order(Timestamp dateTime, User user, Book book, int quantityOrdered, Date deliveryDate) {
		super();
		this.dateTime = dateTime;
		this.user = user;
		this.book = book;
		this.quantityOrdered = quantityOrdered;
		this.deliveryDate = deliveryDate;
	}
	
	public Order(Timestamp dateTime, User user, Book book, Date deliveryDate) {
		super();
		this.dateTime = dateTime;
		this.user = user;
		this.book = book;
		this.deliveryDate = deliveryDate;
	}

	public Timestamp getDateTime() {
		return dateTime;
	}

	public void setDateTime(Timestamp dateTime) {
		this.dateTime = dateTime;
	}

	public User getUser() {
		return user;
	}

	public void setUser(User user) {
		this.user = user;
	}

	public Book getBook() {
		return book;
	}

	public void setBook(Book book) {
		this.book = book;
	}

	public int getQuantityOrdered() {
		return quantityOrdered;
	}

	public void setQuantityOrdered(int quantityOrdered) {
		this.quantityOrdered = quantityOrdered;
	}

	public Date getDeliveryDate() {
		return deliveryDate;
	}
	
	public java.sql.Date getSQLDeliveryDate(){
		java.sql.Date sDeliveryDate = new java.sql.Date(deliveryDate.getTime());
		return sDeliveryDate;
	}

	public void setDeliveryDate(Date deliveryDate) {
		this.deliveryDate = deliveryDate;
	}

}

package com.bookstore.models;

import java.util.LinkedList;

public class Book {
	private int id;
	private String title;
	private String author;
	private int quantity;
	private int quantityOrdered;
	private double unitPrice;
	private long isbn;
	private int edition;
	
	public Book () {}
	public Book(String title, String author, int quantity, double unitPrice, long isbn) {
		super();
		this.title = title;
		this.author = author;
		this.quantity = quantity;
		this.unitPrice = unitPrice;
		this.isbn = isbn;
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getAuthor() {
		return author;
	}

	public void setAuthor(String author) {
		this.author = author;
	}

	public int getQuantity() {
		return quantity;
	}

	public void setQuantity(int quantity) {
		this.quantity = quantity;
	}

	public double getUnitPrice() {
		return unitPrice;
	}

	public void setUnitPrice(double unitPrice) {
		this.unitPrice = unitPrice;
	}

	public long getIsbn() {
		return isbn;
	}

	public void setIsbn(long isbn) {
		this.isbn = isbn;
	}
	
	public int getQuantityOrdered() {
		return quantityOrdered;
	}

	public void setQuantityOrdered(int quantityOredered) {
		this.quantityOrdered = quantityOredered;
	}

	public int getEdition() {
		return edition;
	}

	public void setEdition(int edition) {
		this.edition = edition;
	}

	@Override
	public String toString() {
		return "Book [title=" + title + ", author=" + author + ", quantity=" + quantity + ", unitPrice=" + unitPrice
				+ ", isbn=" + isbn + "]";
	}
	
	public static double getTotalPrice(LinkedList<Book> ordered_book) {
		double total_price = 0;
		for(Book book : ordered_book) {
			total_price += book.getQuantityOrdered() * book.getUnitPrice(); 
		}
		return total_price;
	}
	
	
	
}

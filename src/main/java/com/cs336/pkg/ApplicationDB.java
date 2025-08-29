package com.cs336.pkg;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class ApplicationDB {
    
	String connectionUrl = "jdbc:mysql://localhost:3306/TravelSystemDB?useSSL=false&serverTimezone=UTC";
    
    public ApplicationDB() {
        // Default constructor
    }

    public Connection getConnection(){
        Connection connection = null;
        
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            connection = DriverManager.getConnection(connectionUrl, "root", "cs336rutgers");
            
            if (connection != null) {
                System.out.println("Connected to the database!");
            }
        } catch (ClassNotFoundException e) {
            System.out.println("MySQL JDBC Driver not found.");
            e.printStackTrace();
        } catch (SQLException e) {
            System.out.println("Connection failed: " + e.getMessage());
            e.printStackTrace();
        }
        
        return connection;
    }

    // Method to close the database connection
    public void closeConnection(Connection connection) {
        try {
            if (connection != null && !connection.isClosed()) {
                connection.close();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Main method to test the connection
    public static void main(String[] args) {
        ApplicationDB dao = new ApplicationDB();
        Connection connection = dao.getConnection();

        // Print the connection to check if it's valid
        if (connection != null) {
            System.out.println("Connected to database!");
        } else {
            System.out.println("Failed to connect to database.");
        }

        dao.closeConnection(connection);
    }
}

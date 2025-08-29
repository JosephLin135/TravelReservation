<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="com.cs336.pkg.ApplicationDB" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Operations</title>
</head>
<body>

<h2>Admin Operations: Manage Customer Representatives and Customers</h2>

<!-- Form to add a new customer representative or customer -->
<h3>Add a New Customer Representative/Customer</h3>
<form method="POST" action="AdminOperations.jsp">
    <label for="username">Username:</label>
    <input type="text" name="username" required><br><br>

    <label for="password">Password:</label>
    <input type="password" name="password" required><br><br>

    <label for="action">Action:</label>
    <select name="action">
        <option value="addCustomerRep">Add Customer Representative</option>
        <option value="addCustomer">Add Customer</option>
    </select><br><br>

    <button type="submit">Submit</button>
</form>

<!-- Form to edit a customer representative or customer -->
<h3>Edit an Existing Customer Representative/Customer</h3>
<form method="POST" action="AdminOperations.jsp">
    <label for="username">Username:</label>
    <input type="text" name="username" required><br><br>

    <label for="newPassword">New Password:</label>
    <input type="password" name="newPassword" required><br><br>

    <label for="action">Action:</label>
    <select name="action">
        <option value="editCustomerRep">Edit Customer Representative</option>
        <option value="editCustomer">Edit Customer</option>
    </select><br><br>

    <button type="submit">Submit</button>
</form>

<!-- Form to delete a customer representative or customer -->
<h3>Delete a Customer Representative/Customer</h3>
<form method="POST" action="AdminOperations.jsp">
    <label for="username">Username:</label>
    <input type="text" name="username" required><br><br>

    <label for="action">Action:</label>
    <select name="action">
        <option value="deleteCustomerRep">Delete Customer Representative</option>
        <option value="deleteCustomer">Delete Customer</option>
    </select><br><br>

    <button type="submit">Submit</button>
</form>

<%
    // Admin check: Ensure the user is logged in and is an admin
    if (session.getAttribute("role") == null || !session.getAttribute("role").equals("admin")) {
        response.sendRedirect("AdminLogin.jsp");  // Redirect to AdminLogin.jsp if not logged in as admin
        return;
    }

    // Get form data
    String action = request.getParameter("action");
    String username = request.getParameter("username");
    String password = request.getParameter("password");
    String newPassword = request.getParameter("newPassword");

    Connection connection = null;
    PreparedStatement stmt = null;

    try {
        // Connect to the database
        ApplicationDB db = new ApplicationDB();
        connection = db.getConnection();

        // Add Customer Representative
        if ("addCustomerRep".equals(action)) {
            String insertCustomerRepQuery = "INSERT INTO customerrep (repuser, reppass) VALUES (?, ?)";
            stmt = connection.prepareStatement(insertCustomerRepQuery);
            stmt.setString(1, username);
            stmt.setString(2, password);
            stmt.executeUpdate();
            out.println("Customer Representative added successfully!");

        // Add Customer
        } else if ("addCustomer".equals(action)) {
            String insertCustomerQuery = "INSERT INTO customer (username, password) VALUES (?, ?)";
            stmt = connection.prepareStatement(insertCustomerQuery);
            stmt.setString(1, username);
            stmt.setString(2, password);
            stmt.executeUpdate();
            out.println("Customer added successfully!");

        // Edit Customer Representative's Password
        } else if ("editCustomerRep".equals(action)) {
            String updateCustomerRepQuery = "UPDATE customerrep SET reppass = ? WHERE repuser = ?";
            stmt = connection.prepareStatement(updateCustomerRepQuery);
            stmt.setString(1, newPassword);
            stmt.setString(2, username);
            stmt.executeUpdate();
            out.println("Customer Representative password updated successfully!");

        // Edit Customer's Password
        } else if ("editCustomer".equals(action)) {
            String updateCustomerQuery = "UPDATE customer SET password = ? WHERE username = ?";
            stmt = connection.prepareStatement(updateCustomerQuery);
            stmt.setString(1, newPassword);
            stmt.setString(2, username);
            stmt.executeUpdate();
            out.println("Customer password updated successfully!");

        // Delete Customer Representative
        } else if ("deleteCustomerRep".equals(action)) {
            String deleteCustomerRepQuery = "DELETE FROM customerrep WHERE repuser = ?";
            stmt = connection.prepareStatement(deleteCustomerRepQuery);
            stmt.setString(1, username);
            stmt.executeUpdate();
            out.println("Customer Representative deleted successfully!");

        // Delete Customer
        } else if ("deleteCustomer".equals(action)) {
            String deleteCustomerQuery = "DELETE FROM customer WHERE username = ?";
            stmt = connection.prepareStatement(deleteCustomerQuery);
            stmt.setString(1, username);
            stmt.executeUpdate();
            out.println("Customer deleted successfully!");
        }
    } catch (SQLException e) {
        e.printStackTrace();
        out.println("Error: " + e.getMessage());
    } finally {
        try {
            if (stmt != null) stmt.close();
            if (connection != null) connection.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
%>

</body>
</html>

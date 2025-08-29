<%@ page import="com.cs336.pkg.ApplicationDB" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.Statement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Top Customer Revenue</title>
</head>
<body>
<%
    // Check if the user is logged in and if the role is admin
    if (session.getAttribute("user") == null || session.getAttribute("role") == null || !session.getAttribute("role").equals("admin")) {
        response.sendRedirect("AdminLogin.jsp");  // Redirect to login if not logged in or not an admin
        return;
    }

    // Initialize database connection and query execution
    ApplicationDB db = new ApplicationDB();
    Connection con = db.getConnection();  
    Statement stmt = con.createStatement();

    // Query to find the top customer by total revenue
    String query = "SELECT username, SUM(fare) AS total_revenue " + 
                   "FROM tickets " + 
                   "GROUP BY username " + 
                   "ORDER BY total_revenue DESC LIMIT 1";

    // Execute the query
    ResultSet rs = stmt.executeQuery(query);

    // Check if there is a result and display it
    if (rs.next()) {
        String topCustomer = rs.getString("username");
        String totalRevenue = rs.getString("total_revenue");
%>

<h3>Top Customer by Revenue:</h3>
<p>Customer: <%= topCustomer %></p>
<p>Total Revenue: $<%= totalRevenue %></p>

<%
    } else {
        out.println("<p>No data found for top customer.</p>");
    }
%>
    
<p><a href="AdminSuccess.jsp">Back to Admin Dashboard</a></p>
</body>
</html>

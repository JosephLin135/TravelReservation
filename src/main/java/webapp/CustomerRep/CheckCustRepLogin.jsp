<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Check Customer Representative Login</title>
</head>
<body>
	<%@ page import ="java.sql.*" %>
<%
    String userid = request.getParameter("Username");   
    String pass = request.getParameter("Password");
    
    ApplicationDB db = new ApplicationDB();	
    Connection con = db.getConnection();	
    PreparedStatement stmt = null;
    ResultSet rs = null;
    
    try {
        // Prevent SQL Injection: Use prepared statement to securely query the database
        String query = "SELECT * FROM customerrep WHERE repuser = ? AND reppass = ?";
        stmt = con.prepareStatement(query);
        stmt.setString(1, userid);  // Set username parameter
        stmt.setString(2, pass);    // Set password parameter
        rs = stmt.executeQuery();

        if (rs.next()) {   // If user is found in the database
            session.setAttribute("user", userid);      // Set user session
            session.setAttribute("role", "customerrep"); // Set role as customer representative
            response.sendRedirect("CustRepSuccess.jsp"); // Redirect to CustomerRepSuccess.jsp page
        } else {
            out.println("Invalid username or password. <a href='CustomerRepLogin.jsp'>Try again</a>");
        }
    } catch (SQLException e) {
        e.printStackTrace();
        out.println("Database error: " + e.getMessage());
    } finally {
        // Close the resources
        try {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (con != null) con.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
%>
</body>
</html>

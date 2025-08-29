<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.cs336.pkg.ApplicationDB"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Login</title>
</head>
<body>
<%
    String userid = request.getParameter("Username");
    String pass = request.getParameter("Password");

    ApplicationDB db = new ApplicationDB();
    Connection con = db.getConnection();
    Statement stmt = con.createStatement();

    // Check if the user exists and the password matches
    ResultSet rs = stmt.executeQuery("SELECT * FROM admin WHERE adminuser='" + userid + "' AND adminpass='" + pass + "'");
    
    if (rs.next()) {
        // Successful login, set session attributes
        session.setAttribute("user", userid);
        session.setAttribute("role", "admin");  // Set role as admin
        response.sendRedirect("AdminSuccess.jsp"); // Redirect to Admin Success page
    } else {
        // Invalid login, show error message
        out.println("Invalid username or password <a href='AdminLogin.jsp'>Try Again</a>");
    }
%>
</body>
</html>

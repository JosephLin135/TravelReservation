<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Create Admin Account</title>
</head>
<body>

<%
    String userid = request.getParameter("Username");
    String pass = request.getParameter("Password");

    ApplicationDB db = new ApplicationDB();    
    Connection con = db.getConnection();    

    if (con == null) {
        out.println("Failed to connect to database. Check JDBC driver and DB credentials.");
    } else {
        try {
            Statement stmt = con.createStatement();
            ResultSet rs = stmt.executeQuery("SELECT * FROM admin WHERE adminuser='" + userid + "'");
            if (rs.next()) {
                out.println("Username exists, please try another <a href='NewAdminAcc.jsp'>try again</a>");
            } else {
                int x = stmt.executeUpdate("INSERT INTO admin (adminuser, adminpass) VALUES('" + userid + "', '" + pass + "')");
                session.setAttribute("user", userid);
                response.sendRedirect("AdminSuccess.jsp");
            }
        } catch (SQLException e) {
            out.println("Database error: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                con.close();
            } catch (Exception e) {}
        }
    }
%>

</body>
</html>

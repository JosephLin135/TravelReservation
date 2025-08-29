<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" import="com.cs336.pkg.ApplicationDB" %>
<%@ page import="java.sql.*" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Waiting List Confirmation</title>
</head>
<body>

<%
  // 1) Authentication
  String user = (String) session.getAttribute("user");
  if (user == null) {
    response.sendRedirect("CustomerLogin.jsp");
    return;
  }

  // 2) Read parameters
  String airlineId  = request.getParameter("airline_id");
  String aircraftId = request.getParameter("aircraft_id");
  String depDateStr = request.getParameter("dep_date");

  // 3) Validate inputs
  if (airlineId == null || airlineId.isEmpty()
   || aircraftId == null || aircraftId.isEmpty()
   || depDateStr == null || depDateStr.isEmpty()) {

    out.println("<p style='color:red;'>All fields are required to join the waiting list.</p>");
    out.println("<p><a href='CustSuccess.jsp'>Back to Dashboard</a></p>");
    return;
  }

  // 4) Insert into waitinglist
  Connection conn = null;
  PreparedStatement ps = null;
  try {
    ApplicationDB db = new ApplicationDB();
    conn = db.getConnection();

    String sql = "INSERT INTO waitinglist (username, airline_id, aircraft_id, dep_date) "
               + "VALUES (?, ?, ?, ?)";
    ps = conn.prepareStatement(sql);
    ps.setString(1, user);
    ps.setString(2, airlineId);
    ps.setString(3, aircraftId);

    // Convert 'YYYY-MM-DD' string to java.sql.Date
    java.sql.Date sqlDate = java.sql.Date.valueOf(depDateStr);
    ps.setDate(4, sqlDate);

    int count = ps.executeUpdate();
    if (count > 0) {
      out.println("<p style='color:green;'>Thank you, "
                + user
                + ". You have been added to the waiting list for flight "
                + airlineId + "/" + aircraftId
                + " on " + depDateStr
                + ".</p>");
    } else {
      out.println("<p style='color:red;'>Failed to join waiting list. Please try again.</p>");
    }
  } catch (SQLException e) {
    out.println("<p style='color:red;'>Error: " 
              + e.getMessage()
              + "</p>");
  } finally {
    if (ps   != null) try { ps.close();   } catch(Exception ignore){}
    if (conn != null) try { conn.close(); } catch(Exception ignore){}
  }
%>

<p><a href="CustSuccess.jsp">Back to Dashboard</a></p>

</body>
</html>

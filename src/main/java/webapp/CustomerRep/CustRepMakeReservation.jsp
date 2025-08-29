<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Make Flight Reservation</title>
  <style>
    fieldset { margin-bottom: 2em; padding: 1em; }
    legend   { font-weight: bold; }
  </style>
</head>
<body>
<%
    String role = (String) session.getAttribute("role");
    if (session.getAttribute("user") == null || role == null || !role.equals("customerrep")) {
%>
    <p>You are not logged in.</p>
    <a href="CustomerRepLogin.jsp">Please Login</a>
<%
    } else {
        // Processing the form submission
        String username = request.getParameter("username");
        String depAirport = request.getParameter("dep_airport");
        String depDate = request.getParameter("dep_date");
        String arrAirport = request.getParameter("arr_airport");
        String arrDate = request.getParameter("arr_date");
        String ticketClass = request.getParameter("ticket_class");

        // Insert your reservation logic here (e.g., insert into DB)
        if (username != null && depAirport != null && depDate != null && arrAirport != null && arrDate != null && ticketClass != null) {
            // Reservation logic here
            out.println("<p>Reservation made successfully for " + username + "!</p>");
        }
%>

    <h2>Make a Flight Reservation</h2>

    <form action="CustRepMakeReservation.jsp" method="POST">
        Customer Username:<br>
        <input type="text" name="username" required><br><br>
        Departure Airport / Date:<br>
        <input type="text" name="dep_airport" required>
        <input type="date" name="dep_date" required><br><br>
        Arrival Airport / Date:<br>
        <input type="text" name="arr_airport" required>
        <input type="date" name="arr_date" required><br><br>
        Class:<br>
        <select name="ticket_class" required>
            <option value="economy">Economy</option>
            <option value="business">Business</option>
            <option value="first">First</option>
        </select><br><br>
        <input type="submit" value="Book Reservation">
    </form>
<%
    }
%>
</body>
</html>

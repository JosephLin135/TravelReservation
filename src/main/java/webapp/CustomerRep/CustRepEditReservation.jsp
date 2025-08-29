<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Edit Existing Reservation</title>
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
        String purchaseDT = request.getParameter("purchaseDT");
        String newClass = request.getParameter("new_class");
        String newDepDate = request.getParameter("new_dep_date");
        String newDepTime = request.getParameter("new_dep_time");

        // Insert your reservation editing logic here (e.g., update in DB)
        if (username != null && purchaseDT != null) {
            // Edit reservation logic here
            out.println("<p>Reservation for " + username + " has been updated successfully!</p>");
        }
%>

    <h2>Edit an Existing Reservation</h2>

    <form action="CustRepEditReservation.jsp" method="POST">
        Customer Username:<br>
        <input type="text" name="username" required><br><br>
        Ticket ID (Username + PurchaseDT):<br>
        <input type="text" name="purchaseDT" placeholder="YYYY-MM-DD HH:MM:SS" required><br><br>
        New Class:<br>
        <select name="new_class">
            <option value="">-- leave unchanged --</option>
            <option value="economy">Economy</option>
            <option value="business">Business</option>
            <option value="first">First</option>
        </select><br><br>
        New Departure Date:<br>
        <input type="date" name="new_dep_date"><br><br>
        New Departure Time:<br>
        <input type="time" name="new_dep_time"><br><br>
        <input type="submit" value="Update Reservation">
    </form>
<%
    }
%>
</body>
</html>

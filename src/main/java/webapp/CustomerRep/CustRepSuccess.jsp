<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Customer Representative Dashboard</title>
  <style>
    fieldset { margin-bottom: 2em; padding: 1em; }
    legend   { font-weight: bold; }
    .btn     { margin-right: 0.5em; }
  </style>
</head>
<body>
<%
    String role = (String)session.getAttribute("role");
    if (session.getAttribute("user") == null 
        || role == null 
        || !role.equals("customerrep")) {
%>
    <p>You are not logged in.</p>
    <a href="CustomerRepLogin.jsp">Please Login</a>
<%
    } else {
%>
    <p>
      Welcome, <%= session.getAttribute("user") %>
      <span style="float: right;"><a href="CustomerRepLogout.jsp">Log out</a></span>
    </p>
    <h2>Customer Representative Dashboard</h2>

    <!-- Link back to operations menu -->
    <a href="CustomerRepOperations.jsp" class="btn">
      <button type="button">Customer Rep Operations</button>
    </a>

    <!-- FAQ Management Link -->
    <a href="CustRepFAQs.jsp" class="btn">
      <button type="button">View &amp; Manage Customer Questions</button>
    </a>
    <br><br>

    <!-- Airport Flight Log -->
    <fieldset>
      <legend>Produce Flight Log for an Airport</legend>
      <form action="CustRepAirportFlights.jsp" method="POST">
        Airport ID:<br>
        <input type="text" name="airport_id" placeholder="E.g. LAX" required><br><br>
        <input type="submit" value="Retrieve Flights">
      </form>
    </fieldset>

    <!-- Passenger Waiting List -->
    <fieldset>
      <legend>Retrieve Passenger Waiting List</legend>
      <form action="CustRepWaitingList.jsp" method="POST">
        Airline ID: <input type="text" name="airline_id" required>
        Aircraft ID: <input type="text" name="aircraft_id" required>
        Date: <input type="date" name="dep_date" required>
        <input type="submit" value="Retrieve">
      </form>
    </fieldset>

    <!-- Make Flight Reservation -->
    <fieldset>
      <legend>Make Flight Reservation for Customer</legend>
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
    </fieldset>

    <!-- Edit Existing Reservation -->
    <fieldset>
      <legend>Edit Existing Reservation</legend>
      <form action="CustRepEditReservation.jsp" method="POST">
        Customer Username:<br>
        <input type="text" name="username" required><br><br>
        Ticket ID (Username + PurchaseDT):<br>
        <input type="text"
               name="purchaseDT"
               placeholder="YYYY-MM-DD HH:MM:SS"
               required><br><br>
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
    </fieldset>
<%
    }
%>
</body>
</html>

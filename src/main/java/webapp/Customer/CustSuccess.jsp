<%@ page language="java"
         contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"
         import="java.sql.*, com.cs336.pkg.ApplicationDB" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Customer Dashboard</title>
  <style>
    fieldset { margin-bottom: 20px; padding: 10px; }
    legend { font-weight: bold; }
    .top-links { float: right; }
    .top-links a { margin-left: 10px; }
  </style>
</head>
<body>
<%
  String user = (String) session.getAttribute("user");
  if (user == null) {
    response.sendRedirect("CustomerLogin.jsp");
    return;
  }
%>

<h2>Welcome, <%= user %>!</h2>
<div class="top-links">
  <a href="CustomerFAQs.jsp">FAQs</a>
  <a href="CustomerReservations.jsp">My Reservations</a>
  <a href="CustLogout.jsp">Log out</a>
</div>
<br clear="all">

<!-- ==== 1) Search Flights ==== -->
<fieldset>
  <legend>Search Flights</legend>
  <form action="CustomerBooking.jsp" method="POST">
    Trip Type:
    <select name="triptype">
      <option value="oneway">One-way</option>
      <option value="roundtrip">Round-trip</option>
      <option value="flexible">Flexible (+/– 3 days)</option>
    </select><br><br>

    Departure Airport:
    <input type="text" name="dep_airport" placeholder="EWR, JFK, LGA">
    Date:
    <input type="date" name="departing_date">
    <br><br>

    Arrival Airport:
    <input type="text" name="arr_airport" placeholder="EWR, JFK, LGA">
    <br><br>

    Sort By:
    <select name="sortby">
      <option value="econ_rate">Economy Price</option>
      <option value="bus_rate">Business Price</option>
      <option value="first_rate">First-Class Price</option>
      <option value="dep_time">Departure Time</option>
      <option value="arr_time">Arrival Time</option>
    </select>

    Max Price:
    <input type="number" name="maxprice" min="0" step="1">
    <br><br>

    <button type="submit">Search</button>
  </form>
</fieldset>

<!-- ==== 2) Book a Trip ==== -->
<fieldset>
  <legend>Book a Trip</legend>
  <form action="CustomerBooking.jsp" method="POST">
    Flight ID (airline_aircraft_date):
    <input type="text" name="flight_key" placeholder="AA001_AC101_2025-06-17">
    <br><br>
    Class:
    <select name="travel_class">
      <option value="economy">Economy</option>
      <option value="business">Business</option>
      <option value="first">First-Class</option>
    </select>
    <br><br>
    <button type="submit">Book Reservation</button>
  </form>
</fieldset>

<!-- ==== 3) My Reservations (Cancel) ==== -->
<fieldset>
  <legend>Cancel Reservation (Business/First Class Only)</legend>
  <form action="CustomerCancelation.jsp" method="POST">
    Select Ticket (PurchaseDT):
    <%
      ApplicationDB db1 = new ApplicationDB();
      Connection conn1 = db1.getConnection();
      PreparedStatement pst = conn1.prepareStatement(
        "SELECT purchaseDT FROM tickets WHERE username = ? AND travel_class IN ('business', 'first')");
      pst.setString(1, user);
      ResultSet rset = pst.executeQuery();
    %>
      <select name="purchaseDT">
        <option value="" disabled selected>-- select ticket --</option>
    <%
      while (rset.next()) {
        String dt = rset.getString("purchaseDT");
    %>
        <option value="<%= dt %>"><%= dt %></option>
    <%
      }
      rset.close();
      pst.close();
      conn1.close();
    %>
      </select>
      <br><br>
      <button type="submit">Cancel Reservation</button>
  </form>
</fieldset>

<!-- ==== 4) Join Flight Waiting List ==== -->
<fieldset>
  <legend>Join Flight Waiting List</legend>
  <form action="CustWaitingList.jsp" method="POST">
    Airline ID:
    <input type="text" name="airline_id" required><br><br>
    Aircraft ID:
    <input type="text" name="aircraft_id" required><br><br>
    Departure Date:
    <input type="date" name="dep_date" required><br><br>
    <button type="submit">Join Waiting List</button>
  </form>
</fieldset>

<!-- ==== 5) View My Reservations (Past/Upcoming) ==== -->
<fieldset>
  <legend>View My Reservations</legend>
  <form action="CustomerReservations.jsp" method="POST">
    <input type="submit" name="type" value="Upcoming Flights">
    <input type="submit" name="type" value="Past Flights">
  </form>
</fieldset>

<!-- ==== 6) Ask a Question ==== -->
<fieldset>
  <legend>Ask a Question</legend>
  <form action="CustomerFAQs.jsp" method="POST">
    <button type="submit">Click to go to FAQs</button>
  </form>
</fieldset>

</body>
</html>

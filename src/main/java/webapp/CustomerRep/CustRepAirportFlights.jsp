<%@ page import="java.sql.*, com.cs336.pkg.ApplicationDB" %>
<%
    String airport = request.getParameter("airport_id");
    ApplicationDB db = new ApplicationDB();
    Connection con = db.getConnection();
    PreparedStatement ps = con.prepareStatement(
        "SELECT airline_id, aircraft_id, dep_date, dep_airport, arr_airport, arr_time " +
        "FROM flights " +
        "WHERE dep_airport = ? OR arr_airport = ?"
    );
    ps.setString(1, airport);
    ps.setString(2, airport);

    ResultSet rs = ps.executeQuery();
%>

<h2>Flights for Airport: <%= airport %></h2>
<table border="1">
  <tr>
    <th>Airline</th><th>Aircraft</th><th>Dep Date</th>
    <th>Dep Airport</th><th>Arr Airport</th><th>Arr Time</th>
  </tr>
<%
    while (rs.next()) {
%>
  <tr>
    <td><%= rs.getString("airline_id") %></td>
    <td><%= rs.getString("aircraft_id") %></td>
    <td><%= rs.getDate("dep_date") %></td>
    <td><%= rs.getString("dep_airport") %></td>
    <td><%= rs.getString("arr_airport") %></td>
    <td><%= rs.getTime("arr_time") %></td>
  </tr>
<%
    }
    rs.close();
    ps.close();
    con.close();
%>
</table>

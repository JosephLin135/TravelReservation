<%@ page import="java.sql.*, java.util.*, com.cs336.pkg.ApplicationDB" %>
<%@ page session="true" %>
<%
    String user = (String) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("CustomerLogin.jsp");
        return;
    }

    // Retrieve form parameters
    String depAirport = request.getParameter("dep_airport");
    String arrAirport = request.getParameter("arr_airport");
    String departingDate = request.getParameter("departing_date");

    String maxPrice = request.getParameter("maxprice");
    String maxStops = request.getParameter("max_stops");
    String airline = request.getParameter("airline");
    String depTimeStart = request.getParameter("dep_time_start");
    String depTimeEnd = request.getParameter("dep_time_end");
    String arrTimeStart = request.getParameter("arr_time_start");
    String arrTimeEnd = request.getParameter("arr_time_end");
    String sortBy = request.getParameter("sortby");

    ApplicationDB db = new ApplicationDB();
    Connection conn = db.getConnection();

    // Build SQL query dynamically
    StringBuilder query = new StringBuilder("SELECT *, TIMEDIFF(arr_time, dep_time) AS duration FROM flights WHERE 1=1");
    List<Object> params = new ArrayList<>();

    if (depAirport != null && !depAirport.isEmpty()) {
        query.append(" AND dep_airport = ?");
        params.add(depAirport);
    }
    if (arrAirport != null && !arrAirport.isEmpty()) {
        query.append(" AND arr_airport = ?");
        params.add(arrAirport);
    }
    if (departingDate != null && !departingDate.isEmpty()) {
        query.append(" AND arr_date = ?");
        params.add(departingDate);
    }
    if (maxPrice != null && !maxPrice.isEmpty()) {
        query.append(" AND econ_rate <= ?");
        params.add(Double.parseDouble(maxPrice));
    }
    if (maxStops != null && !maxStops.isEmpty()) {
        query.append(" AND stops <= ?");
        params.add(Integer.parseInt(maxStops));
    }
    if (airline != null && !airline.isEmpty()) {
        query.append(" AND airline_name LIKE ?");
        params.add("%" + airline + "%");
    }
    if (depTimeStart != null && depTimeEnd != null && !depTimeStart.isEmpty() && !depTimeEnd.isEmpty()) {
        query.append(" AND dep_time BETWEEN ? AND ?");
        params.add(depTimeStart);
        params.add(depTimeEnd);
    }
    if (arrTimeStart != null && arrTimeEnd != null && !arrTimeStart.isEmpty() && !arrTimeEnd.isEmpty()) {
        query.append(" AND arr_time BETWEEN ? AND ?");
        params.add(arrTimeStart);
        params.add(arrTimeEnd);
    }

    // Sort by criteria
    if (sortBy != null && !sortBy.isEmpty()) {
        switch (sortBy) {
            case "price":
                query.append(" ORDER BY econ_rate ASC");
                break;
            case "takeoff":
                query.append(" ORDER BY dep_time ASC");
                break;
            case "landing":
                query.append(" ORDER BY arr_time ASC");
                break;
            case "duration":
                query.append(" ORDER BY duration ASC");
                break;
        }
    }

    PreparedStatement pst = conn.prepareStatement(query.toString());
    for (int i = 0; i < params.size(); i++) {
        pst.setObject(i + 1, params.get(i));
    }

    ResultSet rs = pst.executeQuery();
%>

<html>
<head><title>Available Flights</title></head>
<body>
<h2>Available Flights</h2>
<form method="get" action="CustomerBooking.jsp">
    Departure: <input type="text" name="dep_airport" value="<%= depAirport != null ? depAirport : "" %>"/>
    Arrival: <input type="text" name="arr_airport" value="<%= arrAirport != null ? arrAirport : "" %>"/>
    Date: <input type="date" name="departing_date" value="<%= departingDate != null ? departingDate : "" %>"/>
    Max Price: <input type="text" name="maxprice" value="<%= maxPrice != null ? maxPrice : "" %>"/>
    Max Stops: <input type="number" name="max_stops" value="<%= maxStops != null ? maxStops : "" %>"/>
    Airline: <input type="text" name="airline" value="<%= airline != null ? airline : "" %>"/><br><br>

    Take-off Time: From <input type="time" name="dep_time_start" value="<%= depTimeStart != null ? depTimeStart : "" %>"/>
    To <input type="time" name="dep_time_end" value="<%= depTimeEnd != null ? depTimeEnd : "" %>"/>
    Landing Time: From <input type="time" name="arr_time_start" value="<%= arrTimeStart != null ? arrTimeStart : "" %>"/>
    To <input type="time" name="arr_time_end" value="<%= arrTimeEnd != null ? arrTimeEnd : "" %>"/><br><br>

    Sort by:
    <select name="sortby">
        <option value="">--Select--</option>
        <option value="price">Price</option>
        <option value="takeoff">Take-off Time</option>
        <option value="landing">Landing Time</option>
        <option value="duration">Duration</option>
    </select>
    <input type="submit" value="Search Flights"/>
</form>
<br>

<table border="1">
    <tr>
        <th>Flight</th>
        <th>Airline</th>
        <th>Date</th>
        <th>Departure</th>
        <th>Arrival</th>
        <th>Stops</th>
        <th>Economy</th>
        <th>Business</th>
        <th>First</th>
        <th>Book</th>
    </tr>
<%
    while (rs.next()) {
        String key = rs.getString("airline_id") + "_" +
                     rs.getString("aircraft_id") + "_" +
                     rs.getString("arr_date");
%>
    <tr>
        <td><%= key %></td>
        <td><%= rs.getString("airline_id") %></td>
        <td><%= rs.getString("arr_date") %></td>
        <td><%= rs.getString("dep_time") %></td>
        <td><%= rs.getString("arr_time") %></td>
        <td><%= rs.getInt("stops") %></td>
        <td>$<%= rs.getDouble("econ_rate") %></td>
        <td>$<%= rs.getDouble("bus_rate") %></td>
        <td>$<%= rs.getDouble("first_rate") %></td>
        <td>
            <form method="post" action="CustomerBooking.jsp">
                <input type="hidden" name="flight_key" value="<%= key %>"/>
                <select name="travel_class">
                    <option value="economy">Economy</option>
                    <option value="business">Business</option>
                    <option value="first">First</option>
                </select>
                <input type="submit" value="Book"/>
            </form>
        </td>
    </tr>
<%
    }
    rs.close();
    pst.close();
    conn.close();
%>
</table>
<br>
<a href="CustSuccess.jsp">Back to Dashboard</a>
</body>
</html>

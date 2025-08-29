<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="com.cs336.pkg.ApplicationDB" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Customer Rep Operations</title>
</head>
<body>

<h2>Customer Representative Operations: Manage Aircraft, Airports, and Flights</h2>
	
<!-- Add Flight -->
<h3>Add New Flight</h3>
<form method="POST" action="CustomerRepOperations.jsp">
    <label for="airline_id">Airline ID:</label>
    <input type="text" name="airline_id" required><br><br>

    <label for="aircraft_id">Aircraft ID:</label>
    <input type="text" name="aircraft_id" required><br><br>

    <label for="dep_date">Departure Date:</label>
    <input type="date" name="dep_date" required><br><br>

    <label for="dep_airport">Departure Airport:</label>
    <input type="text" name="dep_airport" required><br><br>

    <label for="dep_time">Departure Time:</label>
    <input type="time" name="dep_time" required><br><br>

    <label for="arr_airport">Arrival Airport:</label>
    <input type="text" name="arr_airport" required><br><br>

    <label for="arr_time">Arrival Time:</label>
    <input type="time" name="arr_time" required><br><br>

    <label for="type">Flight Type:</label>
    <input type="text" name="type" required><br><br>

    <label for="stops">Number of Stops:</label>
    <input type="number" name="stops" required><br><br>

    <label for="econ_rate">Economy Price:</label>
    <input type="number" name="econ_rate" required><br><br>

    <label for="bus_rate">Business Price:</label>
    <input type="number" name="bus_rate" required><br><br>

    <label for="first_rate">First Class Price:</label>
    <input type="number" name="first_rate" required><br><br>

    <button type="submit" name="action" value="addFlight">Add Flight</button>
</form>

<!-- Edit Flight -->
<h3>Edit Existing Flight</h3>
<form method="POST" action="CustomerRepOperations.jsp">
    <label for="flights_id">Flight ID to Edit:</label>
    <input type="text" name="flight_id" required><br><br>

    <!-- Additional input fields for editing flight details -->
    <label for="new_dep_date">New Departure Date:</label>
    <input type="date" name="new_dep_date"><br><br>

    <label for="new_dep_airport">New Departure Airport:</label>
    <input type="text" name="new_dep_airport"><br><br>

    <label for="new_dep_time">New Departure Time:</label>
    <input type="time" name="new_dep_time"><br><br>

    <label for="new_arr_airport">New Arrival Airport:</label>
    <input type="text" name="new_arr_airport"><br><br>

    <label for="new_arr_time">New Arrival Time:</label>
    <input type="time" name="new_arr_time"><br><br>

    <label for="new_type">New Flight Type:</label>
    <input type="text" name="new_type"><br><br>

    <label for="new_stops">New Number of Stops:</label>
    <input type="number" name="new_stops"><br><br>

    <label for="new_econ_rate">New Economy Price:</label>
    <input type="number" name="new_econ_rate"><br><br>

    <label for="new_bus_rate">New Business Price:</label>
    <input type="number" name="new_bus_rate"><br><br>

    <label for="new_first_rate">New First Class Price:</label>
    <input type="number" name="new_first_rate"><br><br>

    <button type="submit" name="action" value="editFlight">Edit Flight</button>
</form>

<!-- Delete Flight -->
<h3>Delete Flight</h3>
<form method="POST" action="CustomerRepOperations.jsp">
    <label for="flight_id">Flight ID to Delete:</label>
    <input type="text" name="flights_id" required><br><br>

    <button type="submit" name="action" value="deleteFlight">Delete Flight</button>
</form>

<!-- Add Aircraft -->
<h3>Add New Aircraft</h3>
<form method="POST" action="CustomerRepOperations.jsp">
    <label for="aircraft_id">Aircraft ID:</label>
    <input type="text" name="aircraft_id" required><br><br>

    <button type="submit" name="action" value="addAircraft">Add Aircraft</button>
</form>

<!-- Edit Aircraft -->
<h3>Edit Existing Aircraft</h3>
<form method="POST" action="CustomerRepOperations.jsp">
    <label for="aircraft_id">Aircraft ID to Edit:</label>
    <input type="text" name="aircraft_id" required><br><br>

    <button type="submit" name="action" value="editAircraft">Edit Aircraft</button>
</form>

<!-- Delete Aircraft -->
<h3>Delete Aircraft</h3>
<form method="POST" action="CustomerRepOperations.jsp">
    <label for="aircraft_id">Aircraft ID to Delete:</label>
    <input type="text" name="aircraft_id" required><br><br>

    <button type="submit" name="action" value="deleteAircraft">Delete Aircraft</button>
</form>

<!-- Add Airport -->
<h3>Add New Airport</h3>
<form method="POST" action="CustomerRepOperations.jsp">
    <label for="airport_id">Airport ID:</label>
    <input type="text" name="airport_id" required><br><br>

    <button type="submit" name="action" value="addAirport">Add Airport</button>
</form>

<!-- Edit Airport -->
<h3>Edit Existing Airport</h3>
<form method="POST" action="CustomerRepOperations.jsp">
    <label for="airport_id">Airport ID to Edit:</label>
    <input type="text" name="airport_id" required><br><br>

    <button type="submit" name="action" value="editAirport">Edit Airport</button>
</form>

<!-- Delete Airport -->
<h3>Delete Airport</h3>
<form method="POST" action="CustomerRepOperations.jsp">
    <label for="airport_id">Airport ID to Delete:</label>
    <input type="text" name="airport_id" required><br><br>

    <button type="submit" name="action" value="deleteAirport">Delete Airport</button>
</form>

<%
    if (session.getAttribute("role") == null || !session.getAttribute("role").equals("customerrep")) {
        response.sendRedirect("CustomerRepLogin.jsp");  // Redirect to CustomerRepLogin.jsp if not logged in
        return;
    }

    // Get form data
    String action = request.getParameter("action");
    String airlineId = request.getParameter("airline_id");
    String aircraftId = request.getParameter("aircraft_id");
    String depDate = request.getParameter("dep_date");
    String depAirport = request.getParameter("dep_airport");
    String depTime = request.getParameter("dep_time");
    String arrAirport = request.getParameter("arr_airport");
    String arrTime = request.getParameter("arr_time");
    String type = request.getParameter("type");
    String stops = request.getParameter("stops");
    String econRate = request.getParameter("econ_rate");
    String busRate = request.getParameter("bus_rate");
    String firstRate = request.getParameter("first_rate");
    String arrDate = request.getParameter("arr_date");
    String flightId = request.getParameter("flights_id");
    String airportId = request.getParameter("airport_id");
    String airportName = request.getParameter("airport_name");
    String airportLocation = request.getParameter("airport_location");
    String aircraftModel = request.getParameter("aircraft_model");

    Connection connection = null;
    PreparedStatement stmt = null;

    try {
        // Connect to the database
        ApplicationDB db = new ApplicationDB();
        connection = db.getConnection();

        // Add New Flight
        if ("addFlight".equals(action)) {
            String insertFlightQuery = "INSERT INTO flights (airline_id, aircraft_id, dep_date, dep_airport, dep_time, arr_airport, arr_time, type, stops, econ_rate, bus_rate, first_rate, arr_date) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            stmt = connection.prepareStatement(insertFlightQuery);
            stmt.setString(1, airlineId);
            stmt.setString(2, aircraftId);
            stmt.setString(3, depDate);
            stmt.setString(4, depAirport);
            stmt.setString(5, depTime);
            stmt.setString(6, arrAirport);
            stmt.setString(7, arrTime);
            stmt.setString(8, type);
            stmt.setInt(9, Integer.parseInt(stops));  // Convert stops to integer
            stmt.setInt(10, Integer.parseInt(econRate));  // Convert economy rate to integer
            stmt.setInt(11, Integer.parseInt(busRate));  // Convert business rate to integer
            stmt.setInt(12, Integer.parseInt(firstRate));  // Convert first class rate to integer
            stmt.setString(13, arrDate);
            stmt.executeUpdate();
            out.println("Flight added successfully!");

        // Edit Existing Flight
        } else if ("editFlight".equals(action)) {
            String updateFlightQuery = "UPDATE flights SET airline_id = ?, aircraft_id = ?, dep_date = ?, dep_airport = ?, dep_time = ?, arr_airport = ?, arr_time = ?, type = ?, stops = ?, econ_rate = ?, bus_rate = ?, first_rate = ?, arr_date = ? WHERE flights_id = ?";
            stmt = connection.prepareStatement(updateFlightQuery);
            stmt.setString(1, airlineId);
            stmt.setString(2, aircraftId);
            stmt.setString(3, depDate);
            stmt.setString(4, depAirport);
            stmt.setString(5, depTime);
            stmt.setString(6, arrAirport);
            stmt.setString(7, arrTime);
            stmt.setString(8, type);
            stmt.setInt(9, Integer.parseInt(stops));  // Convert stops to integer
            stmt.setInt(10, Integer.parseInt(econRate));  // Convert economy rate to integer
            stmt.setInt(11, Integer.parseInt(busRate));  // Convert business rate to integer
            stmt.setInt(12, Integer.parseInt(firstRate));  // Convert first class rate to integer
            stmt.setString(13, arrDate);
            stmt.setInt(14, Integer.parseInt(flightId));  // Convert flightId to integer
            stmt.executeUpdate();
            out.println("Flight updated successfully!");

        // Delete Flight
        } else if ("deleteFlight".equals(action)) {
            String deleteFlightQuery = "DELETE FROM flights WHERE flights_id = ?";
            stmt = connection.prepareStatement(deleteFlightQuery);
            stmt.setInt(1, Integer.parseInt(flightId));  // Convert flightId to integer
            stmt.executeUpdate();
            out.println("Flight deleted successfully!");
        }

            // Add New Airport
            else if ("addAirport".equals(action)) {
                String insertAirportQuery = "INSERT INTO airports (airport_id) VALUES (?)";
                stmt = connection.prepareStatement(insertAirportQuery);
                stmt.setString(1, airportId);
                stmt.setString(2, airportName);
                stmt.setString(3, airportLocation);
                stmt.executeUpdate();
                out.println("Airport added successfully!");

            // Edit Existing Airport
            } else if ("editAirport".equals(action)) {
                String updateAirportQuery = "UPDATE airports SET airport_id = ? WHERE airport_id = ?";
                stmt = connection.prepareStatement(updateAirportQuery);
                stmt.setString(1, airportName);
                stmt.setString(2, airportLocation);
                stmt.setString(3, airportId);
                stmt.executeUpdate();
                out.println("Airport updated successfully!");

            // Delete Airport
            } else if ("deleteAirport".equals(action)) {
                String deleteAirportQuery = "DELETE FROM airports WHERE airport_id = ?";
                stmt = connection.prepareStatement(deleteAirportQuery);
                stmt.setString(1, airportId);
                stmt.executeUpdate();
                out.println("Airport deleted successfully!");
            }

            // Add New Aircraft
            else if ("addAircraft".equals(action)) {
                String insertAircraftQuery = "INSERT INTO aircraft (aircraft_id) VALUES (?)";
                stmt = connection.prepareStatement(insertAircraftQuery);
                stmt.setString(1, aircraftId);
                stmt.executeUpdate();
                out.println("Aircraft added successfully!");

            // Edit Existing Aircraft
            } else if ("editAircraft".equals(action)) {
                String updateAircraftQuery = "UPDATE aircraft SET aircraft_id = ? WHERE aircraft_id = ?";
                stmt = connection.prepareStatement(updateAircraftQuery);
                stmt.setString(1, aircraftId);
                stmt.executeUpdate();
                out.println("Aircraft updated successfully!");

            // Delete Aircraft
            } else if ("deleteAircraft".equals(action)) {
                String deleteAircraftQuery = "DELETE FROM aircraft WHERE aircraft_id = ?";
                stmt = connection.prepareStatement(deleteAircraftQuery);
                stmt.setString(1, aircraftId);
                stmt.executeUpdate();
                out.println("Aircraft deleted successfully!");
            }
    } catch (SQLException e) {
        e.printStackTrace();
        out.println("An error occurred. Please try again.");
    } finally {
        try {
            if (stmt != null) {
                stmt.close();
            }
            if (connection != null) {
                connection.close();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
%>

</body>
</html>

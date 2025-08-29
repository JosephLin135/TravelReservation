<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.cs336.pkg.ApplicationDB" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.Statement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.sql.PreparedStatement" %>  <!-- Ensure this import is here -->

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Customer FAQs</title>
</head>
<body>
    <h2>Frequently Asked Questions</h2>
    <a href="CustSuccess.jsp">Back to Dashboard</a>
    <br><br>

    <form action="CustomerFAQs.jsp" method="GET">
        <input type="text" name="keyword" placeholder="Search by keyword">
        <input type="submit" value="Search">
    </form>

    <hr>

    <%
        // Database connection
        ApplicationDB db = new ApplicationDB();
        Connection con = db.getConnection();
        Statement stmt = con.createStatement();
        ResultSet rs1;

        // Get keyword for search
        String keyword = request.getParameter("keyword");

        // Query to fetch all questions (answered and unanswered)
        String query = "SELECT * FROM questions WHERE question LIKE '%" + (keyword != null ? keyword : "") + "%'";

        try {
            rs1 = stmt.executeQuery(query);

            boolean found = false;

            while (rs1.next()) {
                String question = rs1.getString("question");
                String status = rs1.getString("status");

                out.println("<div>");
                out.println("<strong>Q:</strong> " + question + "<br>");
                if (status.equals("answered")) {
                    String answer = rs1.getString("answer");
                    out.println("<strong>A:</strong> " + answer + "<br>");
                } else {
                    out.println("<strong>A:</strong> (Answer will be provided by the customer representative)<br>");
                }
                out.println("</div><br>");
                found = true;
            }

            if (!found) {
                out.println("<p>No FAQs matched your search.</p>");
            }

        } catch (SQLException e) {
            out.println("<p>Error while fetching questions: " + e.getMessage() + "</p>");
        } finally {
            try {
                if (stmt != null) stmt.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    %>

    <h3>Post a New Question</h3>
    <form action="CustomerFAQs.jsp" method="POST">
        <textarea name="newQuestion" rows="4" cols="50" placeholder="Ask your question here"></textarea><br>
        <input type="submit" value="Post Question">
    </form>

    <%
        // Handle new question submission
        if (request.getMethod().equalsIgnoreCase("POST")) {
            String newQuestion = request.getParameter("newQuestion");

            if (newQuestion != null && !newQuestion.trim().isEmpty()) {
                Connection conForInsert = null; // Separate connection for the insert query
                PreparedStatement insertStmt = null;
                try {
                    String username = (String) session.getAttribute("user");

                    if (username != null) {
                        conForInsert = db.getConnection(); // Ensure a fresh connection is opened here
                        String insertQuery = "INSERT INTO questions (question, status, username) VALUES (?, 'unanswered', ?)";
                        insertStmt = conForInsert.prepareStatement(insertQuery);
                        insertStmt.setString(1, newQuestion); // Set the question text
                        insertStmt.setString(2, username); // Set the username
                        insertStmt.executeUpdate();

                        out.println("<p>Your question has been posted successfully.</p>");
                    } else {
                        out.println("<p>You must be logged in to post a question.</p>");
                    }
                } catch (SQLException e) {
                    out.println("<p>Error while posting question: " + e.getMessage() + "</p>");
                } finally {
                    try {
                        if (insertStmt != null) insertStmt.close();
                        if (conForInsert != null) conForInsert.close();
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                }
            } else {
                out.println("<p>Please enter a valid question.</p>");
            }
        }
    %>

</body>
</html>

<%@ page language="java" contentType="text/html; charset=UTF-8" 
    pageEncoding="UTF-8" %>
<%@ page import="com.cs336.pkg.ApplicationDB" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.Statement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.SQLException" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Customer Rep FAQs</title>
</head>
<body>
<%
  // Validate login & role
  if (session.getAttribute("user") == null ||
      session.getAttribute("role") == null ||
      !"customerrep".equals(session.getAttribute("role"))) {
    response.sendRedirect("CustomerRepLogin.jsp");
    return;
  }
%>

<p style="float:right;">
  <a href="CustRepSuccess.jsp">Back to Dashboard</a>
  &nbsp;|&nbsp;
  <a href="CustomerRepLogout.jsp">Log out</a>
</p>

<h2>All Customer Questions</h2>

<!-- table header -->
<table border="1" cellpadding="5" cellspacing="0">
  <tr>
    <th>ID</th>
    <th>Question</th>
    <th>Status</th>
    <th>Answer</th>
    <th>Asked By</th>
    <th>At</th>
    <th>Actions</th>
  </tr>

<%
  // 1) Display existing questions
  ApplicationDB db = new ApplicationDB();
  Connection con = null;
  Statement stmt = null;
  ResultSet rs = null;

  try {
    con = db.getConnection();
    stmt = con.createStatement();
    String sql = "SELECT question_id, question, status, "
               + "IFNULL(answer,'(unanswered)') AS answer, "
               + "username, created_at "
               + "FROM questions "
               + "ORDER BY created_at DESC";
    rs = stmt.executeQuery(sql);

    while (rs.next()) {
%>
      <tr>
        <td><%= rs.getInt("question_id") %></td>
        <td><%= rs.getString("question") %></td>
        <td><%= rs.getString("status") %></td>
        <td><%= rs.getString("answer") %></td>
        <td><%= rs.getString("username") %></td>
        <td><%= rs.getTimestamp("created_at") %></td>
        <td>
          <!-- Answer form -->
          <form method="post" style="display:inline">
            <input type="hidden" name="question_id"
                   value="<%= rs.getInt("question_id") %>"/>
            <input type="text" name="answer" size="20"
                   placeholder="Answer..." required/>
            <button type="submit" name="action" value="answer">
              Submit Answer
            </button>
          </form>

          <!-- Delete form -->
          <form method="post" style="display:inline"
                onsubmit="return confirm('Delete question #<%= rs.getInt("question_id") %>?');">
            <input type="hidden" name="question_id"
                   value="<%= rs.getInt("question_id") %>"/>
            <button type="submit" name="action" value="delete">
              Delete
            </button>
          </form>
        </td>
      </tr>
<%
    }
  } catch (SQLException e) {
    out.println("<tr><td colspan='7' style='color:red;'>"
              + "Error loading questions: " + e.getMessage()
              + "</td></tr>");
  } finally {
    if (rs != null) try { rs.close(); } catch(Exception ignore) {}
    if (stmt != null) try { stmt.close(); } catch(Exception ignore) {}
    if (con != null)  try { con.close(); } catch(Exception ignore) {}
  }


  // 2) Handle POST (answer or delete) *after* rendering the table
  String action = request.getParameter("action");
  String qidStr = request.getParameter("question_id");
  String answer = request.getParameter("answer");

  if (action != null && qidStr != null) {
    int qid = Integer.parseInt(qidStr);
    Connection c2 = null;
    PreparedStatement ps = null;
    try {
      c2 = db.getConnection();

      if ("answer".equals(action)) {
        String upd = "UPDATE questions SET answer=?, status='answered' "
                   + "WHERE question_id=?";
        ps = c2.prepareStatement(upd);
        ps.setString(1, answer);
        ps.setInt(2, qid);

      } else if ("delete".equals(action)) {
        String del = "DELETE FROM questions WHERE question_id=?";
        ps = c2.prepareStatement(del);
        ps.setInt(1, qid);
      }

      if (ps != null) ps.executeUpdate();

    } catch (SQLException ex) {
      out.println("<p style='color:red;'>Action failed: "
                + ex.getMessage() + "</p>");
    } finally {
      if (ps != null) try { ps.close(); } catch(Exception ignore) {}
      if (c2 != null) try { c2.close(); } catch(Exception ignore) {}
    }

    // Refresh page so changes reflect immediately
    response.sendRedirect("CustRepFAQs.jsp");
  }
%>

</table>

</body>
</html>

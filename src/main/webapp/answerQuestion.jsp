<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.cs336.pkg.ApplicationDB" %>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Answer a Question</title>
<style>
    table {
        width: 100%;
        border-collapse: collapse;
    }

    table, th, td {
        border: 1px solid black;
    }

    th, td {
        padding: 10px;
        text-align: left;
    }

    th {
        background-color: #f2f2f2;
    }

    td {
        text-align: center;
    }

    form {
        margin-top: 20px;
    }
</style>
</head>
<body>

<%
    String username = (String) session.getAttribute("username");

    if (username == null) {
        out.println("<p>Please log in to answer questions.</p>");
    } else {
        Connection conn = null;
        try {
            ApplicationDB db = new ApplicationDB();
            conn = db.getConnection();
            
            String questionId = request.getParameter("questionId");
            String answerBody = request.getParameter("answerBody");

            if (questionId != null && answerBody != null && !answerBody.trim().isEmpty()) {
                String insertAnswerQuery = "INSERT INTO posts (parent_id, type, username, body) VALUES (?, 'answer', ?, ?)";
                PreparedStatement insertStmt = conn.prepareStatement(insertAnswerQuery);
                insertStmt.setInt(1, Integer.parseInt(questionId));
                insertStmt.setString(2, username);
                insertStmt.setString(3, answerBody);

                int rowsInserted = insertStmt.executeUpdate();

                if (rowsInserted > 0) {
                    out.println("<p>Answer submitted successfully!</p>");
                } else {
                    out.println("<p>Failed to submit answer. Please try again.</p>");
                }

                insertStmt.close();
            }

            String fetchQuery = "SELECT q.id AS question_id, q.body AS question_body, q.username AS question_username, " +
                                "a.body AS answer_body, a.username AS answer_username " +
                                "FROM posts q " +
                                "LEFT JOIN posts a ON q.id = a.parent_id AND a.type = 'answer' " +
                                "WHERE q.type = 'question'";

            PreparedStatement fetchStmt = conn.prepareStatement(fetchQuery);
            ResultSet rs = fetchStmt.executeQuery();
%>

<h3>Available Questions:</h3>
<table>
    <thead>
        <tr>
            <th>Question ID</th>
            <th>Customer Username</th>
            <th>Question</th>
            <th>Answer</th>
            <th>Customer Representative Username</th>
        </tr>
    </thead>
    <tbody>
<%
            while (rs.next()) {
%>
        <tr>
            <td><%= rs.getInt("question_id") %></td>
            <td><%= rs.getString("question_username") %></td>
            <td><%= rs.getString("question_body") %></td>
            <td><%= rs.getString("answer_body") != null ? rs.getString("answer_body") : "No answer yet" %></td>
            <td><%= rs.getString("answer_username") != null ? rs.getString("answer_username") : "N/A" %></td>
        </tr>
<%
            }
            rs.close();
            fetchStmt.close();
        } catch (Exception e) {
            e.printStackTrace();
            out.println("<p>Error: " + e.getMessage() + "</p>");
        } finally {
            if (conn != null) conn.close();
        }
    }
%>
    </tbody>
</table>

<h3>Answer a Question:</h3>
<form method="post" action="answerQuestion.jsp">
    <label for="questionId">Question ID:</label>
    <input type="number" id="questionId" name="questionId" required><br><br>

    <label for="answerBody">Your Answer:</label><br>
    <textarea id="answerBody" name="answerBody" rows="5" cols="50" required></textarea><br><br>

    <button type="submit">Submit Answer</button>
</form>

<div style="margin-top: 20px;">
    <a href="customerRepresentativeHome.jsp">
        <button type="button">Back to Home Page</button>
    </a>
</div>

</body>
</html>

<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ page import="com.cs336.pkg.ApplicationDB"%>

<%
    String question = request.getParameter("question");
	String username = (String) session.getAttribute("username");

    if (question != null && !question.trim().isEmpty()) {
    	Connection conn = null;
        try {
        	
        	ApplicationDB db = new ApplicationDB();
        	conn = db.getConnection();

            String query = "INSERT INTO posts (type, body, username) VALUES (?, ?, ?)";
            PreparedStatement stmt = conn.prepareStatement(query);
            stmt.setString(1, "question");
            stmt.setString(2, question);
            stmt.setString(3, username);

            int rowsAffected = stmt.executeUpdate();

            if (rowsAffected > 0) {
                out.println("<p>Question submitted successfully!</p>");
            } else {
                out.println("<p>Failed to submit the question. Please try again.</p>");
            }
            stmt.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
            out.println("<p>Error: " + e.getMessage() + "</p>");
        }
    } else {
        out.println("<p>Invalid question submission. Please fill out the form properly.</p>");
    }
%>
<div style="margin-top: 20px;">
    <form action="customerHome.jsp" method="get">
        <button type="submit">Back to Home Page</button>
    </form>
</div>

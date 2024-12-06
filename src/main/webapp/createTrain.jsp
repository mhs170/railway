<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.cs336.pkg.ApplicationDB" %>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Add Train</title>
</head>
<body>
<div>
<%

String trainId = (String) request.getParameter("train_id");
PreparedStatement stmt = null;
Connection conn = null;

if (trainId == null || trainId.trim().isEmpty()) {
    out.println("<p>Error: Train ID is required.</p>");
} else {
    try {
        
        ApplicationDB db = new ApplicationDB();
        conn = db.getConnection();

        
        String insertQuery = "INSERT INTO trains (train_id) VALUES (?)";
        stmt = conn.prepareStatement(insertQuery);
        stmt.setString(1, trainId);
        int rowsAffected = stmt.executeUpdate();

        if (rowsAffected > 0) {
            out.println("<p>Train ID " + trainId + " inserted successfully!</p>");
            out.println("<div style='margin-top: 20px;'>");
            out.println("<a href='customerRepresentativeHome.jsp'><button type='button'>Back to Home</button></a>");
            out.println("</div>");
        } else {
            out.println("<p>Failed to insert Train ID.</p>");
        }
    } catch (Exception e) {
        out.println("<p>Error: " + e.getMessage() + "</p>");
    } finally {
        
        try {
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        } catch (SQLException ex) {
            out.println("<p>Error closing resources: " + ex.getMessage() + "</p>");
        }
    }
}


%>

</div>
</body>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.cs336.pkg.ApplicationDB" %>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>



<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Add Station</title>
</head>
<body>
<%

String stationID = (String) request.getParameter("station_id");
String stationName = (String) request.getParameter("station_name");
String stationCity= (String) request.getParameter("station_city");
String state = (String) request.getParameter("state");

PreparedStatement stmt = null;
Connection conn = null;

try {
    
    ApplicationDB db = new ApplicationDB();
    conn = db.getConnection();

    
    String insertQuery = "INSERT INTO stations VALUES (?, ?, ?, ?)";
    stmt = conn.prepareStatement(insertQuery);
    stmt.setString(1, stationID);
    stmt.setString(2, stationName);
    stmt.setString(3, stationCity);
    stmt.setString(4, state);
    
    int rowsAffected = stmt.executeUpdate();

    if (rowsAffected > 0) {
        out.println("<p>" + stationName +" inserted successfully!</p>");
        out.println("<div style='margin-top: 20px;'>");
        out.println("<a href='customerRepresentativeHome.jsp'><button type='button'>Back to Home</button></a>");
        out.println("</div>");
    } else {
        out.println("<p>Failed to insert Station.</p>");
    }
}catch (SQLIntegrityConstraintViolationException e) {
    // station ID already exists
    out.println("<p>Error: Station ID " + stationID + " is already taken. Please choose a different Station ID.</p>");
    
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

    
%>



</body>
</html>
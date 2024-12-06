<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.cs336.pkg.ApplicationDB" %>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>



<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Add Stop</title>
</head>
<body>
<%

String transit_line_name = (String) request.getParameter("transit_line_name");
String stationID = (String) request.getParameter("stationID");
String stopArrival = (String) request.getParameter("stop_arrival");
String stopDeparture = (String) request.getParameter("stop_departure");


PreparedStatement stmt = null;
Connection conn = null;

try {
    
    ApplicationDB db = new ApplicationDB();
    conn = db.getConnection();

    
    String insertQuery = "INSERT INTO stops VALUES (?, ?, ?, ?)";
    stmt = conn.prepareStatement(insertQuery);
    stmt.setString(1, transit_line_name);
    stmt.setString(2, stationID);
    stmt.setString(3, stopArrival);
    stmt.setString(4, stopDeparture);
    
    int rowsAffected = stmt.executeUpdate();

    if (rowsAffected > 0) {
        out.println("<p>Successfully inserted stop!</p>");
        out.println("<div style='margin-top: 20px;'>");
        out.println("<a href='customerRepresentativeHome.jsp'><button type='button'>Back to Home</button></a>");
        out.println("</div>");
    } else {
        out.println("<p>Failed to insert Station.</p>");
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

    
%>



</body>
</html>
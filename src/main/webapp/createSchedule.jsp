<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.cs336.pkg.ApplicationDB" %>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="com.cs336.pkg.createResNumber" %>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>



<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Add Schedule</title>
</head>
<body>
<%

String transit_line_name = (String) request.getParameter("transitLineName");
String trainID = (String) request.getParameter("trainID");
String origin = (String) request.getParameter("origin");
String destination = (String) request.getParameter("destination");
String departure = (String) request.getParameter("departure");
String arrival = (String) request.getParameter("arrival");
String fare = (String) request.getParameter("fare");
String numStops = (String) request.getParameter("num_stops");




PreparedStatement stmt = null;
Connection conn = null;

try {
    
    ApplicationDB db = new ApplicationDB();
    conn = db.getConnection();

	Integer originStationID = createResNumber.getStationID(conn, origin);
	Integer destinationStationID = createResNumber.getStationID(conn, destination);
    
    String insertQuery = "INSERT INTO transit_lines_have VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
    stmt = conn.prepareStatement(insertQuery);
    stmt.setString(1, transit_line_name);
    stmt.setString(2, trainID);
    stmt.setString(3, origin);
    stmt.setString(4, destination);
    stmt.setString(5, arrival);
    stmt.setString(6, departure);
    stmt.setString(7, fare);
    stmt.setString(8, numStops);
    int rowsAffected = stmt.executeUpdate();
    
    
    String insertOriginIntoStopsQuery =  "INSERT INTO stops VALUES (?, ?, ?)";
    stmt = conn.prepareStatement(insertOriginIntoStopsQuery);
    stmt.setString(1, transit_line_name);
    stmt.setInt(2, originStationID);
    stmt.setString(3, departure);
    rowsAffected += stmt.executeUpdate();
    
    String insertDestinationIntoStopsQuery =  "INSERT INTO stops VALUES (?, ?, ?)";
    stmt = conn.prepareStatement(insertOriginIntoStopsQuery);
    stmt.setString(1, transit_line_name);
    stmt.setInt(2, destinationStationID);
    stmt.setString(3, arrival);
    rowsAffected += stmt.executeUpdate();
    
    
	
    if (rowsAffected > 0) {
        out.println("<p>Successfully inserted Schedule!</p>");
        out.println("<div style='margin-top: 20px;'>");
        out.println("<a href='customerRepresentativeHome.jsp'><button type='button'>Back to Home</button></a>");
        out.println("</div>");
    } else {
        out.println("<p>Failed to insert Schedule.</p>");
    }
}catch (SQLIntegrityConstraintViolationException e) {
    // transit line name already exists
    out.println("<p>Error: Transit Line Name " + transit_line_name + " is already taken. Please choose a different Transit Line Name.</p>");
    
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
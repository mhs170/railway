<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.cs336.pkg.ApplicationDB" %>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%
    String transitLineName = request.getParameter("transit_line_name");
    String trainId = request.getParameter("train_id");
    String origin = request.getParameter("origin");
    String destination = request.getParameter("destination");
    String departure = request.getParameter("departure");
    String arrival = request.getParameter("arrival");
    String fare = request.getParameter("fare");
    String numStops = request.getParameter("num_stops");

    Connection conn = null;
    PreparedStatement ps = null;

    try {
        ApplicationDB db = new ApplicationDB();
        conn = db.getConnection();
        String query = "UPDATE transit_lines_have SET train_id = ?, origin = ?, destination = ?, departure = ?, arrival = ?, fare = ?, num_stops = ? WHERE transit_line_name = ?";
        ps = conn.prepareStatement(query);
        ps.setString(1, trainId);
        ps.setString(2, origin);
        ps.setString(3, destination);
        ps.setString(4, departure);
        ps.setString(5, arrival);
        ps.setFloat(6, Float.parseFloat(fare));
        ps.setInt(7, Integer.parseInt(numStops));
        ps.setString(8, transitLineName);

        int rowsUpdated = ps.executeUpdate();

        if (rowsUpdated > 0) {
%>
<div>
    <h2>Schedule updated successfully for <%= transitLineName %>!</h2>
</div>
<%
        } else {
%>
<div>
    <h2>Failed to update schedule for <%= transitLineName %>!</h2>
</div>
<%
        }
    } catch (Exception e) {
        out.println("<div>Error: " + e.getMessage() + "</div>");
    } finally {
        if (ps != null) ps.close();
        if (conn != null) conn.close();
    }
%>

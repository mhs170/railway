<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.cs336.pkg.ApplicationDB" %>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%
    String transitLineName = request.getParameter("line_name");
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    if (transitLineName != null) {
        try {
            ApplicationDB db = new ApplicationDB();
            conn = db.getConnection();
            String query = "SELECT * FROM transit_lines_have WHERE transit_line_name = ?";
            ps = conn.prepareStatement(query);
            ps.setString(1, transitLineName);
            rs = ps.executeQuery();

            if (rs.next()) {
                String trainId = rs.getString("train_id") != null ? rs.getString("train_id") : "";
                String origin = rs.getString("origin") != null ? rs.getString("origin") : "";
                String destination = rs.getString("destination") != null ? rs.getString("destination") : "";
                String departure = rs.getString("departure") != null ? rs.getString("departure") : "";
                String arrival = rs.getString("arrival") != null ? rs.getString("arrival") : "";
                String fare = rs.getString("fare") != null ? rs.getString("fare") : "";
                String numStops = rs.getString("num_stops") != null ? rs.getString("num_stops") : "";
%>
<div>
    <h2>Edit Schedule for <%= transitLineName %></h2>
    <form method="post" action="updateSchedule.jsp">
        <input type="hidden" name="transit_line_name" value="<%= transitLineName %>">
        <label for="train_id">Train ID:</label>
        <input type="text" id="train_id" name="train_id" value="<%= trainId %>"><br>

        <label for="origin">Origin:</label>
        <input type="text" id="origin" name="origin" value="<%= origin %>"><br>

        <label for="destination">Destination:</label>
        <input type="text" id="destination" name="destination" value="<%= destination %>"><br>

        <label for="departure">Departure:</label>
        <input type="text" id="departure" name="departure" value="<%= departure %>"><br>

        <label for="arrival">Arrival:</label>
        <input type="text" id="arrival" name="arrival" value="<%= arrival %>"><br>

        <label for="fare">Fare:</label>
        <input type="text" id="fare" name="fare" value="<%= fare %>"><br>

        <label for="num_stops">Number of Stops:</label>
        <input type="text" id="num_stops" name="num_stops" value="<%= numStops %>"><br>

        <button type="submit">Update Schedule</button>
    </form>
</div>
<%
            } else {
%>
<div>
    <h2>No schedule found for the transit line: <%= transitLineName %></h2>
</div>
<%
            }
        } catch (Exception e) {
            out.println("<div>Error: " + e.getMessage() + "</div>");
        } finally {
            if (rs != null) rs.close();
            if (ps != null) ps.close();
            if (conn != null) conn.close();
        }
    } else {
%>
<div>
    <h2>No transit line specified!</h2>
</div>
<%
    }
%>

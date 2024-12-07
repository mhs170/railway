<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*, javax.servlet.*, javax.servlet.http.*" %>
<%@ page import="com.cs336.pkg.ApplicationDB" %>

<!DOCTYPE html>
<html>
<head>
    <title>Find Schedule By Station</title>
</head>
<body>
    <h2>Transit Line Schedules for Station</h2>
    <%
        String givenStation = request.getParameter("givenStation");
        if (givenStation != null && !givenStation.trim().isEmpty()) {
            Connection conn = null;
            PreparedStatement stmt = null;
            ResultSet rs = null;

            try {
                
                ApplicationDB db = new ApplicationDB();
                conn = db.getConnection();

                
                String query = "SELECT * FROM transit_lines_have WHERE origin = ? OR destination = ?";
                stmt = conn.prepareStatement(query);
                stmt.setString(1, givenStation);
                stmt.setString(2, givenStation);

                
                rs = stmt.executeQuery();

                
                if (rs.isBeforeFirst()) {
    %>
                    <table border="1">
                        <tr>
                            <th>Transit Line Name</th>
                            <th>Train ID</th>
                            <th>Origin</th>
                            <th>Destination</th>
                            <th>Arrival</th>
                            <th>Departure</th>
                            <th>Fare</th>
                            <th>Number of Stops</th>
                        </tr>
    <%
                    while (rs.next()) {
    %>
                        <tr>
                            <td><%= rs.getString("transit_line_name") %></td>
                            <td><%= rs.getInt("train_id") %></td>
                            <td><%= rs.getString("origin") %></td>
                            <td><%= rs.getString("destination") %></td>
                            <td><%= rs.getTimestamp("arrival") %></td>
                            <td><%= rs.getTimestamp("departure") %></td>
                            <td><%= rs.getFloat("fare") %></td>
                            <td><%= rs.getInt("num_stops") %></td>
                        </tr>
    <%
                    }
    %>
                    </table>
    <%
                } else {
                    out.println("<p>No transit lines found for the given station.</p>");
                }
            } catch (Exception e) {
                out.println("<p>Error: " + e.getMessage() + "</p>");
            } finally {
                // Close resources
                if (rs != null) try { rs.close(); } catch (SQLException ignore) {}
                if (stmt != null) try { stmt.close(); } catch (SQLException ignore) {}
                if (conn != null) try { conn.close(); } catch (SQLException ignore) {}
            }
        } else {
            out.println("<p>Error: Station ID is missing or invalid.</p>");
        }
    %>
    <a href="customerRepresentativeHome.jsp">Back to Home Page</a>
</body>
</html>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.*, javax.servlet.http.*" %>
<%@ page import="com.cs336.pkg.ApplicationDB" %>
<!DOCTYPE html>
<html>
<head>
    <title>Find Reservations</title>
</head>
<body>
    <h2>Customer Reservations</h2>
    <%
        String transitLineName = request.getParameter("transit_line_name");
        String date = request.getParameter("date");

        if (transitLineName != null && !transitLineName.trim().isEmpty() && date != null && !date.trim().isEmpty()) {
            Connection conn = null;
            PreparedStatement stmt = null;
            ResultSet rs = null;

            try {
                
                ApplicationDB db = new ApplicationDB();
                conn = db.getConnection();

                
                String query = "SELECT r.username, r.res_number, r.total_fare, r.dateOfDeparture " +
                               "FROM reservations r " +
                               "JOIN transit_lines_have tlh ON r.dateOfDeparture = ? " +
                               "WHERE tlh.transit_line_name = ?";

                stmt = conn.prepareStatement(query);
                stmt.setString(1, date); 
                stmt.setString(2, transitLineName); 


                rs = stmt.executeQuery();

                if (rs.isBeforeFirst()) { 
    %>
                    <table border="1">
                        <tr>
                            <th>Username</th>
                            <th>Reservation Number</th>
                            <th>Total Fare</th>
                            <th>Date of Departure</th>
                        </tr>
    <%
                    while (rs.next()) {
    %>
                        <tr>
                            <td><%= rs.getString("username") %></td>
                            <td><%= rs.getInt("res_number") %></td>
                            <td><%= rs.getFloat("total_fare") %></td>
                            <td><%= rs.getDate("dateOfDeparture") %></td>
                        </tr>
    <%
                    }
    %>
                    </table>
    <%
                } else {
                    out.println("<p>No reservations found for the given transit line and date.</p>");
                }
            } catch (Exception e) {
                out.println("<p>Error: " + e.getMessage() + "</p>");
            } finally {
                
                if (rs != null) try { rs.close(); } catch (SQLException ignore) {}
                if (stmt != null) try { stmt.close(); } catch (SQLException ignore) {}
                if (conn != null) try { conn.close(); } catch (SQLException ignore) {}
            }
        } else {
            out.println("<p>Error: Transit Line Name or Date is missing or invalid.</p>");
        }
    %>
    <a href="customerRepresentativeHome.jsp">Back to Search</a>
</body>
</html>

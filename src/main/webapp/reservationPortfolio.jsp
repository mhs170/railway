<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*, java.util.*"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="ISO-8859-1">
<title>Reservation Portfolio</title>
<style>
    table {
        width: 80%;
        margin: auto;
        border-collapse: collapse;
    }
    table, th, td {
        border: 1px solid black;
    }
    th, td {
        padding: 10px;
        text-align: center;
    }
    th {
        background-color: #f2f2f2;
    }
    h1 {
        text-align: center;
    }
</style>
</head>
<body>
    <h1>Your Reservations</h1>
    <%
        String username = (String) session.getAttribute("username");
        if (username != null) {
            Connection conn = null;
            PreparedStatement stmt = null;
            ResultSet rs = null;
            try {
            	String jdbcUrl = "jdbc:mysql://localhost:3306/cs336project";
                String dbUser = "root";  
                String dbPassword = "2024fall336project";
                conn = DriverManager.getConnection(jdbcUrl, dbUser, dbPassword);
                
                
                String query = "SELECT res_number, total_fare, date FROM reservations WHERE username = ? ORDER BY date DESC";
                stmt = conn.prepareStatement(query);
                stmt.setString(1, username);
                rs = stmt.executeQuery();
    %>
    <table>
        <thead>
            <tr>
                <th>Reservation Number</th>
                <th>Total Fare</th>
                <th>Date</th>
            </tr>
        </thead>
        <tbody>
            <%
                boolean hasReservations = false;
                while (rs.next()) {
                    hasReservations = true;
            %>
            <tr>
                <td><%= rs.getInt("res_number") %></td>
                <td>$<%= rs.getDouble("total_fare") %></td>
                <td><%= rs.getDate("date") %></td>
            </tr>
            <%
                }
                if (!hasReservations) {
            %>
            <tr>
                <td colspan="3">No reservations found.</td>
            </tr>
            <%
                }
            %>
        </tbody>
    </table>
    <%
            } catch (Exception e) {
                out.println("<p>Error: " + e.getMessage() + "</p>");
            } finally {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            }
        } else {
    %>
    <div style="text-align: center;">
        <h2>You are not logged in! Please <a href="login.jsp">login</a>.</h2>
    </div>
    <%
        }
    %>
</body>
</html>

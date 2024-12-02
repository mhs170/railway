<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*"%>
<%
    String username = (String) session.getAttribute("username");
    int resNumber = Integer.parseInt(request.getParameter("res_number"));

    if (username != null) {
        Connection conn = null;
        PreparedStatement stmt = null;
        try {
        	String jdbcUrl = "jdbc:mysql://localhost:3306/cs336project";
            String dbUser = "root"; 
            String dbPassword = "2024fall336project";
            conn = DriverManager.getConnection(jdbcUrl, dbUser, dbPassword);
            
            // Delete reservation query
            String query = "DELETE FROM reservations WHERE res_number = ? AND username = ?";
            stmt = conn.prepareStatement(query);
            stmt.setInt(1, resNumber);
            stmt.setString(2, username);
            int rowsAffected = stmt.executeUpdate();

            if (rowsAffected > 0) {
                out.println("<p>Reservation cancelled successfully!</p>");
            } else {
                out.println("<p>Error: Unable to cancel reservation.</p>");
            }
        } catch (Exception e) {
            out.println("<p>Error: " + e.getMessage() + "</p>");
        } finally {
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        }
    } else {
        response.sendRedirect("login.jsp");
    }
%>
<a href="reservationPortfolio.jsp">Go Back to Reservations</a>

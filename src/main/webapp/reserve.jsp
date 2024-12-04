<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.cs336.pkg.ApplicationDB" %>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ page import="com.cs336.pkg.createResNumber" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Reservation Confirmation</title>
</head>
<body>
<%
    String username = (String) session.getAttribute("username");
    if (username != null) {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            ApplicationDB db = new ApplicationDB();
            conn = db.getConnection();

            // Get form data
            String transitName = request.getParameter("transitName");
            String trainID = request.getParameter("trainID");
            String originStation = request.getParameter("originStation");
            String destinationStation = request.getParameter("destinationStation");
            String discount = request.getParameter("discount");

            // Validate form data (optional)

            // Generate a reservation number
            int resNumber = createResNumber.getNextReservationNumber(conn);

            // Insert reservation into Reservations table
            String reservationQuery = "INSERT INTO Reservations (username, res_number) VALUES (?, ?)";
            ps = conn.prepareStatement(reservationQuery);
            ps.setString(1, username);
            ps.setInt(2, resNumber);
            ps.executeUpdate();
            


            // Insert origin station into Has_Origin table
            String originQuery = "INSERT INTO Has_Origin (res_number, transit_line_name, station_id, username) VALUES (?, ?, ?, ?)";
            ps = conn.prepareStatement(originQuery);
            ps.setInt(1, resNumber);
            ps.setString(2, transitName);
            ps.setInt(3, createResNumber.getStationID(conn, originStation));
            ps.setString(4, username);
            ps.executeUpdate();

            // Insert destination station into Has_destination table (similar to origin)
            String destinationQuery = "INSERT INTO has_destination (res_number, transit_line_name, station_id, username) VALUES (?, ?, ?, ?)";
            ps = conn.prepareStatement(destinationQuery);
            ps.setInt(1, resNumber);
            ps.setString(2, transitName);
            ps.setInt(3, createResNumber.getStationID(conn, originStation));
            ps.setString(4, username);
            ps.executeUpdate();

            // Handle discount (logic depends on your discount implementation)

            out.println("<h3>Reservation Created Successfully!</h3>");
            out.println("Your Reservation Number: " + resNumber);
            // Display additional details if needed (e.g., discount applied)

        } catch (Exception e) {
            out.println("Error creating reservation: " + e.getMessage());
            e.printStackTrace(); // Log the exception for debugging
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    } else {
        out.println("You are not logged in! Please <a href=\"login.jsp\">login</a> again.");
    }
%>
</body>
</html>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" import="java.sql.*, java.util.*, java.time.*, java.time.format.DateTimeFormatter" %>
<%@ page import="com.cs336.pkg.ApplicationDB" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="ISO-8859-1">
    <title>Reservation Portfolio</title>
    <style>
        table {
            width: 80%;
            margin: 20px auto;
            border-collapse: collapse;
        }
        th, td {
            border: 1px solid #ddd;
            padding: 8px;
            text-align: center;
        }
        th {
            background-color: #f4f4f4;
        }
        button {
            padding: 5px 10px;
            cursor: pointer;
        }
        .no-reservations {
            text-align: center;
            margin-top: 20px;
            font-size: 18px;
        }
    </style>
</head>
<body>
    <h1 style="text-align: center;">Your Reservations</h1>
    <div>
        <%
            String username = (String) session.getAttribute("username");
            if (username != null) {
                Connection conn = null;
                PreparedStatement stmt = null;
                ResultSet rs = null;
                try {
                    
                    ApplicationDB db = new ApplicationDB();
                    conn = db.getConnection();
               
                    stmt = conn.prepareStatement("SELECT res_number, total_fare, dateOfDeparture FROM reservations WHERE username = ? ORDER BY dateOfDeparture DESC");
                    stmt.setString(1, username);
                    rs = stmt.executeQuery();

                    List<Map<String, Object>> currentReservations = new ArrayList<Map<String, Object>>();
                    List<Map<String, Object>> pastReservations = new ArrayList<Map<String, Object>>();
                    LocalDateTime now = LocalDateTime.now(); 

                    while (rs.next()) {
                        int resNumber = rs.getInt("res_number");
                        double totalFare = rs.getDouble("total_fare");
                        Timestamp departureDatetime = rs.getTimestamp("dateOfDeparture");
                        LocalDateTime departureDateTime = (departureDatetime != null) ? departureDatetime.toLocalDateTime() : null;

                        Map<String, Object> reservation = new HashMap<String, Object>();
                        reservation.put("resNumber", resNumber);
                        reservation.put("totalFare", totalFare);
                        reservation.put("departureDateTime", departureDateTime);

                        if (departureDateTime != null && departureDateTime.isAfter(now)) {
                            currentReservations.add(reservation);
                        } else {
                            pastReservations.add(reservation);
                        }
                    }
        %>

        
        <h2>Current Reservations</h2>
        <%
            if (!currentReservations.isEmpty()) {
        %>
        <table>
            <thead>
                <tr>
                    <th>Reservation Number</th>
                    <th>Total Fare</th>
                    <th>Date of Departure</th>
                    <th>Status</th>
                </tr>
            </thead>
            <tbody>
                <%
                    for (Map<String, Object> res : currentReservations) {
                        int resNumber = (Integer) res.get("resNumber");
                        double totalFare = (Double) res.get("totalFare");
                        LocalDateTime departureDateTime = (LocalDateTime) res.get("departureDateTime");
                %>
                <tr>
                    <td><%= resNumber %></td>
                    <td>$<%= totalFare %></td>
                    <td>
                        <%
                            if (departureDateTime != null) {
                                out.print(departureDateTime.format(DateTimeFormatter.ofPattern("yyyy-MM-dd")));
                            } else {
                                out.print("N/A");
                            }
                        %>
                    </td>
                    <td>
                        <form method="post" action="cancelReservation.jsp" style="display: inline;" onsubmit="return confirm('Are you sure you want to cancel this reservation?');">
                            <input type="hidden" name="res_number" value="<%= resNumber %>">
                            <button type="submit">Cancel</button>
                        </form>
                    </td>
                </tr>
                <%
                    }
                %>
            </tbody>
        </table>
        <%
            } else {
        %>
        <div class="no-reservations">No current reservations found.</div>
        <%
            }

            // Display Past Reservations
        %>
        <h2>Past Reservations</h2>
        <%
            if (!pastReservations.isEmpty()) {
        %>
        <table>
            <thead>
                <tr>
                    <th>Reservation Number</th>
                    <th>Total Fare</th>
                    <th>Date of Departure</th>
                    <th>Status</th>
                </tr>
            </thead>
            <tbody>
                <%
                    for (Map<String, Object> res : pastReservations) {
                        int resNumber = (Integer) res.get("resNumber");
                        double totalFare = (Double) res.get("totalFare");
                        LocalDateTime departureDateTime = (LocalDateTime) res.get("departureDateTime");
                %>
                <tr>
                    <td><%= resNumber %></td>
                    <td>$<%= totalFare %></td>
                    <td>
                        <%
                            if (departureDateTime != null) {
                                out.print(departureDateTime.format(DateTimeFormatter.ofPattern("yyyy-MM-dd")));
                            } else {
                                out.print("N/A");
                            }
                        %>
                    </td>
                    <td>Past Reservation</td>
                </tr>
                <%
                    }
                %>
            </tbody>
        </table>
        <%
            } else {
        %>
        <div class="no-reservations">No past reservations found.</div>
        <%
            }
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
    </div>
</body>
</html>

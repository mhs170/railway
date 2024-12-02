<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" import="java.sql.*, java.util.*, java.time.*, java.time.format.DateTimeFormatter" %>
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
                    
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    String jdbcUrl = "jdbc:mysql://localhost:3306/cs336project";
                    String dbUser = "root";
                    String dbPassword = "2024fall336project";
                    conn = DriverManager.getConnection(jdbcUrl, dbUser, dbPassword);

               
                    stmt = conn.prepareStatement("SELECT res_number, total_fare, date FROM reservations WHERE username = ? ORDER BY date DESC");
                    stmt.setString(1, username);
                    rs = stmt.executeQuery();

                    boolean hasReservations = false;
                    LocalDateTime now = LocalDateTime.now(); 
        %>
        <table>
            <thead>
                <tr>
                    <th>Reservation Number</th>
                    <th>Total Fare</th>
                    <th>Date and Time</th>
                    <th>Status</th>
                </tr>
            </thead>
            <tbody>
                <%
                    while (rs.next()) {
                        hasReservations = true;
                        int resNumber = rs.getInt("res_number");
                        double totalFare = rs.getDouble("total_fare");
                        Timestamp reservationDatetime = rs.getTimestamp("date");
                        LocalDateTime reservationDateTime = reservationDatetime.toLocalDateTime();
                %>
                <tr>
                    <td><%= resNumber %></td>
                    <td>$<%= totalFare %></td>
                    <td><%= reservationDateTime.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm")) %></td> <!-- Display date and time -->
                    <td>
                        <% if (reservationDateTime.isAfter(now)) { %> 
                            <form method="post" action="cancelReservation.jsp" style="display: inline;">
                                <input type="hidden" name="res_number" value="<%= resNumber %>">
                                <button type="submit">Cancel</button>
                            </form>
                        <% } else { %>
                            Past Reservation
                        <% } %>
                    </td>
                </tr>
                <%
                    }
                    if (!hasReservations) {
                %>
                <tr>
                    <td colspan="5" class="no-reservations">No reservations found.</td>
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
    </div>
</body>
</html>

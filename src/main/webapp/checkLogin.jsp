<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*" %>
<%@ page import="javax.servlet.http.HttpSession" %>
<!DOCTYPE html>
<html>
<head>
    <title>Login Check</title>
</head>
<body>

<%
    
    String jdbcUrl = "jdbc:mysql://localhost:3306/cs336project";
    String dbUser = "root";  // Your DB username
    String dbPassword = "root1234";  // Your DB password
    String username = request.getParameter("username");
    String password = request.getParameter("password");

    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        // Load the MySQL JDBC driver
        Class.forName("com.mysql.cj.jdbc.Driver");

        // Establish connection
        conn = DriverManager.getConnection(jdbcUrl, dbUser, dbPassword);

        // Prepare the SQL statement to check user credentials
        String sql = "SELECT * FROM users WHERE username = ? AND password = ?";
        ps = conn.prepareStatement(sql);
        ps.setString(1, username);
        ps.setString(2, password);

        // Execute query
        rs = ps.executeQuery();

        // Check if the user exists
        if (rs.next()) {
            // User found, set attributes in the session
            session.setAttribute("username", username);

            // Redirect to the home page
            response.sendRedirect("home.jsp");
        } else {
            out.println("Invalid username or password.");
        }
    } catch (Exception e) {
        e.printStackTrace();
        out.println("An error occurred: " + e.getMessage());
    } finally {
        // Close the resources in finally block
        try {
            if (rs != null) rs.close();
            if (ps != null) ps.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
%>

</body>
</html>

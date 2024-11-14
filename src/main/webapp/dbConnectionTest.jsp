<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Database Connection Test</title>
</head>
<body>

<%
    String jdbcUrl = "jdbc:mysql://localhost:3306/cs336project"; 
    String dbUser = "root";  
    String dbPassword = "2024fall336project";

    Connection conn = null;

    try {
        // Load MySQL JDBC driver
        Class.forName("com.mysql.cj.jdbc.Driver");

        // Attempt to establish a connection
        conn = DriverManager.getConnection(jdbcUrl, dbUser, dbPassword);
        
        if (conn != null) {
            out.println("Database connection successful!");
        } else {
            out.println("Failed to connect to the database.");
        }
    } catch (Exception e) {
        e.printStackTrace();
        out.println("An error occurred: " + e.getMessage());
    } finally {
        // Close the connection
        if (conn != null) {
            try {
                conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
%>

</body>
</html>

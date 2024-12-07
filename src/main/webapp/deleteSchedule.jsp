<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.cs336.pkg.ApplicationDB" %>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%
    String username = (String) session.getAttribute("username");
    String transitLineName = (String) request.getParameter("transit_line_name");


    if (username != null) {
        Connection conn = null;
        PreparedStatement stmt = null;
        try {
        	ApplicationDB db = new ApplicationDB();
            conn = db.getConnection();
            
            String query = "DELETE FROM transit_lines_have WHERE transit_line_name= ?";
            stmt = conn.prepareStatement(query);
            stmt.setString(1, transitLineName);
            int rowsAffected = stmt.executeUpdate();

            if (rowsAffected > 0) {
                out.println("<p>Train Schedule deleted successfully!</p>");
            } else {
                out.println("<p>Error: Unable to delete schedule.</p>");
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
<a href="customerRepresentativeHome.jsp">Go Back to Home Page</a>

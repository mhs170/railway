<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.HttpSession" %>
<%@ page import="com.cs336.pkg.ApplicationDB" %>

<!DOCTYPE html>
<html>
<head>
    <title>Login Check</title>
</head>
<body>

<%
    String username = request.getParameter("username");
    String password = request.getParameter("password");
	
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        // 
        // Establish connection
    	ApplicationDB db = new ApplicationDB();	
        conn = db.getConnection(); 

        String sql = "SELECT * FROM users WHERE username = ? AND password = ?";
        ps = conn.prepareStatement(sql);
        ps.setString(1, username);
        ps.setString(2, password);

        rs = ps.executeQuery();

        if (rs.next()) {
            session.setAttribute("username", username);

            String customerCheckSQL = "SELECT * FROM customers WHERE username = ?";
            PreparedStatement psCustomer = conn.prepareStatement(customerCheckSQL);
            psCustomer.setString(1, username);
            ResultSet rsCustomer = psCustomer.executeQuery();

            if (rsCustomer.next()) {
                response.sendRedirect("customerHome.jsp");
            } else {
                String repCheckSQL = "SELECT * FROM customer_representatives WHERE username = ?";
                PreparedStatement psRep = conn.prepareStatement(repCheckSQL);
                psRep.setString(1, username);
                ResultSet rsRep = psRep.executeQuery();

                if (rsRep.next()) {
                    response.sendRedirect("customerRepresentativeHome.jsp");
                } else {
                    String adminCheckSQL = "SELECT * FROM admin WHERE username = ?";
                    PreparedStatement psAdmin = conn.prepareStatement(adminCheckSQL);
                    psAdmin.setString(1, username);
                    ResultSet rsAdmin = psAdmin.executeQuery();

                    if (rsAdmin.next()) {
                        response.sendRedirect("adminHome.jsp");
                    } else {
                        out.println("Role not found.");
                    }

                    rsAdmin.close();
                    psAdmin.close();
                }

                rsRep.close();
                psRep.close();
            }

            rsCustomer.close();
            psCustomer.close();
        } else {
            out.println("Invalid username or password.");
            %>
            <br>
            <h3 class="back-to-login">
				<a href="login.jsp">Back to Login</a>
			</h3>
            <%
        }
    } catch (Exception e) {
        e.printStackTrace();
        out.println("An error occurred: " + e.getMessage());
    } finally {
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

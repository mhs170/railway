<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.cs336.pkg.ApplicationDB, java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Update Customer Representative</title>
</head>
<body>
    <%
        String username = (String) session.getAttribute("username");
    	if(username != null){
    		
    		Connection conn = null;
    		PreparedStatement ps = null;
    		PreparedStatement ps2 = null;
    	    ResultSet rs = null;
    	    
    	    String custRepUsername = request.getParameter("username");
    		String custRepSsn = request.getParameter("ssn");
            String f_name = request.getParameter("f_name");
            String l_name = request.getParameter("l_name");

            
            
            try {
                ApplicationDB db = new ApplicationDB();
                conn = db.getConnection();
                ps = conn.prepareStatement("UPDATE customer_representatives SET ssn = ? WHERE username = ?");
                ps.setString(1, custRepSsn);
                ps.setString(2, custRepUsername);
                ps.executeUpdate();

                ps2 = conn.prepareStatement("UPDATE users SET f_name = ?, l_name = ? WHERE username = ?");
                ps2.setString(1, f_name);
                ps2.setString(2, l_name);
                ps2.setString(3, custRepUsername);
                ps2.executeUpdate();

                out.println("<h2>Customer representative updated successfully.</h2>");
            }catch (Exception e) {
    	    	out.println("ERROR: Could not connect to the database");
    			out.println(e);
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
    		
    		<form action="searchCustomerReps.jsp" method="post">
	        	<input type="hidden" name="action" value="<%= request.getParameter("action") %>">
	        	<input type="hidden" name="custRepUsername" value="<%= custRepUsername %>">
	        	<input type="hidden" name="custRepSsn" value="<%= custRepSsn %>">
				<button>Back to Search</button>
	        </form>
    		<%
    	}else{
    		%>
    		<div style="text-align: center;">
            <h1>You are not logged in! Please <a href="login.jsp">login</a> again. </h1>
        	</div>
        	<%
    	}
    %>
</body>
</html>
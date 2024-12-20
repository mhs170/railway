<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.cs336.pkg.ApplicationDB, java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Delete Customer Representative</title>
    <script type="text/javascript">
        setTimeout(function() {
            window.location.href = "adminHome.jsp";
        }, 5000);
    </script>
</head>
<body>
    <%
        String username = (String) session.getAttribute("username");
    
    	if(username != null){
			
    		Connection conn = null;
    		PreparedStatement ps = null;
    		PreparedStatement ps2 = null;
    	    ResultSet rs = null;
    	    
    	    String action = request.getParameter("action");
    	    String custRepUsername = request.getParameter("custRepUsername");
    	    String custRepSsn = request.getParameter("custRepSsn");
    	    
	        try {
	            ApplicationDB db = new ApplicationDB();
	            conn = db.getConnection();
	           	ps = conn.prepareStatement("DELETE FROM customer_representatives WHERE username = ?");
	           	ps.setString(1, custRepUsername);
	           	ps2 = conn.prepareStatement("DELETE FROM users WHERE username = ?");
	            ps2.setString(1, custRepUsername);
	            
	            try{
		            int rowsDeleted = ps.executeUpdate();
		
		            if (rowsDeleted > 0) {
				        %>
				        <h2>Customer representative deleted successfully.</h2>
				        
				        <p>You will be redirected to the home page in <span id="countdown">5</span> seconds...</p>
        	                
			            <script type="text/javascript">
			                var countdownElement = document.getElementById("countdown");
			                var countdown = 5;
			
			                var countdownInterval = setInterval(function() {
			                    countdown--;
			                    countdownElement.innerText = countdown;
			                    if (countdown <= 0) {
			                        clearInterval(countdownInterval);
			                    }
			                }, 1000);
			            </script>
				        
					    <form action="searchCustomerReps.jsp" method="post">
				        	<input type="hidden" name="action" value="<%= action %>">
				        	<input type="hidden" name="custRepUsername" value="<%= custRepUsername %>">
				        	<input type="hidden" name="custRepSsn" value="<%= custRepSsn %>">
							<button>Back to Search</button>
				        </form>
				        <form action="adminHome.jsp">
							<button>Back to Home</button>
				        </form>
				        <% 
				        
		            } else {
		                out.println("<h2>Error: Customer representative not found.</h2>");
		            }
		            
		            ps2.executeUpdate();
	            }catch(Exception e){
	            	out.println("Bad query.");
	            	//print exception for debugging
    				out.println(e);
	            }
	        } catch (Exception e) {
	            out.println("ERROR: Could not connect to the database");
    			out.println(e);
	        }finally {
    	        try {
    	            if (rs != null) rs.close();
    	            if (ps != null) ps.close();
    	            if (conn != null) conn.close();
    	        } catch (SQLException e) {
    	            e.printStackTrace();
    	            
    	        }
    	    }
	        
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

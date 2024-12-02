<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.cs336.pkg.ApplicationDB" %>

<%
    
    String f_name = request.getParameter("f_name");
    String l_name = request.getParameter("l_name");
    String custRepSsn = request.getParameter("ssn");
    String custRepUsername = request.getParameter("username");
    String custRepPassword = request.getParameter("password");

   /*  String jdbcURL = "jdbc:mysql://localhost:3306/cs336project";
    String dbUsername = "root"; 
    String dbPassword = "2024fall336project"; */

    String insertUserSQL = "INSERT INTO users (username, f_name, l_name, password) VALUES (?, ?, ?, ?)";
    String insertCustomerSQL = "INSERT INTO customer_representatives (username, ssn) VALUES (?, ?)";

    Connection conn = null;
    PreparedStatement pstUser = null;
    PreparedStatement pstCustomer = null;
    
    try {
        // conn = DriverManager.getConnection(jdbcURL, dbUsername, dbPassword);
        ApplicationDB db = new ApplicationDB();
        conn = db.getConnection();
        
        pstUser = conn.prepareStatement(insertUserSQL);
        pstUser.setString(1, custRepUsername);
        pstUser.setString(2, f_name);
        pstUser.setString(3, l_name);
        pstUser.setString(4, custRepPassword);
        int userRowsAffected = pstUser.executeUpdate();
        
        pstCustomer = conn.prepareStatement(insertCustomerSQL);
        pstCustomer.setString(1, custRepUsername);
        pstCustomer.setString(2, custRepSsn);
        int customerRowsAffected = pstCustomer.executeUpdate();

        if (userRowsAffected > 0 && customerRowsAffected > 0) {
        	%>
        	            <html>
        	            <head>
        	                <title>>Register New Customer Representative</title>
        	                <script type="text/javascript">
        	                    setTimeout(function() {
        	                        window.location.href = "adminHome.jsp";
        	                    }, 5000);
        	                </script>
        	            </head>
        	            <body>
        	                <h1>Account Created Successfully</h1>
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
        	                
        	                <form action="adminHome.jsp">
								<button>Back to Home</button>
					        </form>
        	            </body>
        	            </html>
        	<%
        	        } else {
        	            out.println("<h1>Error</h1>");
        	            out.println("<p>There was an error creating your account. Please try again.</p>");
        	        }
        
    } catch (SQLException e) {
        out.println("<h1>Error</h1>");
        out.println("<p>Database error: " + e.getMessage() + "</p>");
    } finally {
        try {
            if (pstUser != null) pstUser.close();
            if (pstCustomer != null) pstCustomer.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
%>

<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ page import="com.cs336.pkg.ApplicationDB"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style>
    body {
        font-family: Arial, sans-serif;
        background-color: #f9f9f9;
        color: #333;
        text-align: center;
        margin: 0;
        padding: 0;
    }
    .container {
        max-width: 600px;
        margin: 50px auto;
        background-color: #fff;
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        border-radius: 8px;
        padding: 20px;
    }
    table {
        width: 100%;
        border-collapse: collapse;
        margin: 20px 0;
    }
    th, td {
        border: 1px solid #ddd;
        padding: 10px;
        text-align: center;
    }
    th {
        background-color: #4CAF50;
        color: white;
    }
    td {
        font-size: 16px;
        color: #555;
    }
    a {
        color: #4CAF50;
        text-decoration: none;
    }
    a:hover {
        text-decoration: underline;
    }
    .back-to-home {
        margin-top: 20px;
    }
</style>
</head>
<body>


<!-- 
-search
	- get transitLineName = request.getParameter(transit_line_name)
	- query:
	SELECT sum(total_fare)
	FROM reservations
	JOIN has_transit USING(username, res_number)
	WHERE transit_line_name = transitLineName
	
	-print result in pretty table
 -->
 
 <%
 String username = (String) session.getAttribute("username");
 if (username != null) {
     Connection conn = null;
     PreparedStatement stmt = null;
     ResultSet rs = null;
    
     try {
     	ApplicationDB db = new ApplicationDB();
     	conn = db.getConnection();
     	
		String action = request.getParameter("action");
		if(action.equals("search")){
			//user pressed search
			String transitLineName = request.getParameter("transit_line_name");
			String query = "SELECT sum(total_fare) revenue FROM reservations JOIN has_transit USING(username, res_number) WHERE transit_line_name = ?";
			stmt = conn.prepareStatement(query);
			stmt.setString(1, transitLineName);
			
			rs = stmt.executeQuery();
			if(rs.next()){
				double revenue = rs.getDouble("revenue");
                %>
                <div class="container">
                    <table>
                        <tr>
                            <th>Transit Line Name</th>
                            <th>Total Revenue</th>
                        </tr>
                        <tr>
                            <td><%= transitLineName %></td>
                            <td>$<%= String.format("%.2f", revenue) %></td>
                        </tr>
                    </table>
                </div>
                <% 
            } else { 
                %>
                <div class="container">
                    <h3>No sales data found for the selected transit line.</h3>
                </div>
                <%
            } 
%>

<%
		}else{
			//view all
			/* 
			- get all the transit lines (passed in hidden inputs)
			- query:
				SELECT transit_line_name, sum(total_fare)
				FROM reservations
				JOIN has_transit USING(username, res_number)
				GROUP BY transit_line_name
				ORDER BY transit_line_name
			*/
			

			String query = "SELECT transit_line_name, sum(total_fare) revenue FROM reservations JOIN has_transit USING(username, res_number) GROUP BY transit_line_name ORDER BY transit_line_name";
			stmt = conn.prepareStatement(query);
			rs = stmt.executeQuery();
			if(rs.next()){
                %>
                <div class="container">
                    <table>
                        <tr>
                            <th>Transit Line Name</th>
                            <th>Total Revenue</th>
                        </tr>
                        
                    <% 
        	        // Loop through all the rows in the result set
                        do{
							double revenue = rs.getDouble("revenue");
                    %>	
                        <tr>
                            <td><%= rs.getString("transit_line_name") %></td>
                            <td>$<%= String.format("%.2f", revenue) %></td>
                        </tr>
                    <%	
                        }while(rs.next());
                	%>
                    </table>
                </div>
                <% 
            } else { 
                %>
                <div class="container">
                    <h3>No sales data found for the selected month.</h3>
                </div>
                <%
            } 
			
		}
		%>
		<!-- back to home link -->
		    <br>
			<h3 class="back-to-home">
				<a href="adminHome.jsp">Back to Home</a>
			</h3>
		<%
     	
     }catch (Exception e) {
         out.println("<p>Error: " + e.getMessage() + "</p>");
     } finally {
         if (rs != null) rs.close();
         if (stmt != null) stmt.close();
         if (conn != null) conn.close();
     }
     
 } else { 
%>
 <div style="text-align: center;">
     <h1>You are not logged in! Please <a href="login.jsp">login</a> again. </h1>
 </div>
<%
 }
%>
 
 
</body>
</html>
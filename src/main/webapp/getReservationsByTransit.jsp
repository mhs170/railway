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
        margin: 0;
        padding: 0;
        text-align: center;
    }
    .container {
        max-width: 800px; /* Increase max-width for better spacing */
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
        table-layout: auto; /* Allow table to adjust column widths automatically */
    }
    th, td {
        border: 1px solid #ddd;
        padding: 12px; /* Increase padding for better spacing */
        text-align: left; /* Align text to the left for better readability */
        word-wrap: break-word; /* Prevent overflow and wrap long text */
    }
    th {
        background-color: #4CAF50;
        color: white;
        font-size: 16px; /* Adjust font size for headers */
    }
    td {
        font-size: 14px; /* Adjust font size for table data */
        color: #555;
    }
    tr:nth-child(even) {
        background-color: #f9f9f9; /* Add alternating row colors */
    }
    tr:hover {
        background-color: #f1f1f1; /* Highlight rows on hover */
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
	SELECT *
 	FROM reservations
 	JOIN has_transit USING(username, res_number)
 	WHERE transit_line_name = ?
 	
 	- sort by different fields:
 		- username, res_number, total_fare, date, dateOfDeparture, transit_line_name
 		
	- similar to searchSchedule format
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
			String query = 	"SELECT * " +
				 			"FROM reservations " +
				 			"JOIN has_transit USING(username, res_number) " +
				 			"JOIN users USING(username)"+
				 			"WHERE transit_line_name = ?";
			stmt = conn.prepareStatement(query);
			stmt.setString(1, transitLineName);
			
			rs = stmt.executeQuery();
			if(rs.next()){
                %>
                <div class="container">
					<div><b>Reservation Data for <%= rs.getString("transit_line_name") %></b></div>
                    <table>
                        <tr>
                            <th>Username</th>
                            <th>First Name</th>
                            <th>Last Name</th>
                            <th>Reservation Number</th>
                            <th>Total Fare</th>
                            <th>Date of Reservation</th>
                        </tr>
                        <% 
        	        // Loop through all the rows in the result set
                        do{
                   		%>	
                        <tr>
                            <td><%= rs.getString("username") %></td>
                            <td><%= rs.getString("f_name") %></td>
                            <td><%= rs.getString("l_name") %></td>
                            <td><%= rs.getString("res_number") %></td>
                            <td>$<%= rs.getString("total_fare") %></td>
                            <td><%= rs.getString("date") %></td>
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
                    <h3>No reservation data found for the selected transit line.</h3>
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
				SELECT transit_line_name, sum(total_fare) revenue
				FROM reservations
				JOIN has_transit USING(username, res_number)
				RIGHT OUTER JOIN transit_lines_have USING (transit_line_name)
				GROUP BY transit_line_name
				ORDER BY transit_line_name
				
				right outer join with transit_lines_have so we can see the names of transit lines with no reservations
			*/
			

			String query = 	"SELECT transit_line_name, username, f_name, l_name, res_number, total_fare, date "+
							"FROM reservations "+
							"JOIN has_transit USING(username, res_number) "+ 
							"JOIN users USING (username) "+
							"ORDER BY transit_line_name, date ";
			stmt = conn.prepareStatement(query);
			rs = stmt.executeQuery();
			if(rs.next()){
                %>
                <div class="container">
                    <table>
                        <tr>
                            <th>Transit Line Name</th>
                            <th>Username</th>
                            <th>First Name</th>
                            <th>Last Name</th>
                            <th>Reservation Number</th>
                            <th>Total Fare</th>
                            <th>Date of Reservation</th>
                        </tr>
                        <% 
        	        // Loop through all the rows in the result set
                        do{
                   		%>	
                        <tr>
                        	<td><%= rs.getString("transit_line_name") %></td>
                            <td><%= rs.getString("username") %></td>
                            <td><%= rs.getString("f_name") %></td>
                            <td><%= rs.getString("l_name") %></td>
                            <td><%= rs.getString("res_number") %></td>
                            <td>$<%= rs.getString("total_fare") %></td>
                            <td><%= rs.getString("date") %></td>
                        </tr>
                    <%	
                        }while(rs.next());
                	%>
                    </table>
                    
                    <% 	stmt = conn.prepareStatement("SELECT count(*) total FROM reservations");
                    	rs = stmt.executeQuery();
						if(rs.next()){
                    	%>
                    <div><b>Total Reservations: <%= rs.getString("total") %></b></div>
                    <%	} 	%>
                    	
                </div>
                <% 
            } else { 
                %>
                <div class="container">
                    <h3>No reservation data found.</h3>
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
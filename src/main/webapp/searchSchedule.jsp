<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- imports -->
<%@ page import="com.cs336.pkg.ApplicationDB" %>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Schedule Search Results</title>
<style>
	table {
        width: 100%;
        border-collapse: collapse;
    }

    table, th, td {
        border: 1px solid black;
    }

    th, td {
        padding: 10px;
        text-align: left;
    }

    th {
        background-color: #f2f2f2;
    }

    td {
        text-align: center;
    }
</style>
</head>
<body>

<% 
    String username = (String) session.getAttribute("username");
    if (username != null) {
		// Grab action
		String action = (String) request.getParameter("action");
		
		Connection conn = null;
	    PreparedStatement ps = null;
	    ResultSet rs = null;
	    
		// try to connect to db
		try{
			ApplicationDB db = new ApplicationDB();
			conn = db.getConnection();
			
			if(action.equals("search")){
				//user pressed search
				
				//Grab origin, destination, dep date and time
				String originStation = (String) request.getParameter("originStation");
				String destinationStation = (String) request.getParameter("destinationStation");
				
				//if origin or dest are null, throw error
				if (originStation == null || originStation.trim().isEmpty() ||
                destinationStation == null || destinationStation.trim().isEmpty()) {
                	out.println("<h3>ERROR: Origin and Destination are required for searching schedules.</h3>");
                			
                	// close connection
                	try {
        	            if (conn != null) conn.close();
        	        } catch (SQLException e) {
        	            e.printStackTrace();
        	            
        	        }
                	%>
                	<div>
	                	<h3 class="back-to-home">
							<a href="customerHome.jsp">Back to Home</a>
						</h3>	                	
                	</div>
                	<%
                	
					return;
            	}
				
				
				String depDate = (String) request.getParameter("depDate");
				String depTime = (String) request.getParameter("depTime");
				// out.println(depTime);
				
				//create query
				String query = "";
				if(!depDate.equals("") && !depTime.equals("")){
					//user entered both date and time
					query = "SELECT * FROM transit_lines_have WHERE origin = ? AND destination = ? AND departure = ?";
					ps = conn.prepareStatement(query);
				    ps.setString(1, originStation);
				    ps.setString(2, destinationStation);
				    ps.setString(3, depDate + depTime);
				}else if(!depDate.equals("")){
					//user entered only date
					query = "SELECT * FROM transit_lines_have WHERE origin = ? AND destination = ? AND DATE(departure) = ?";
					ps = conn.prepareStatement(query);
				    ps.setString(1, originStation);
				    ps.setString(2, destinationStation);
				    ps.setString(3, depDate);
				}else{
					//user entered none 
					query = "SELECT * FROM transit_lines_have WHERE origin = ? AND destination = ?";
					ps = conn.prepareStatement(query);
				    ps.setString(1, originStation);
				    ps.setString(2, destinationStation);
				}
				
			}else if(action.equals("viewAll")){
				//user pressed View All
				
				String query = "SELECT * FROM transit_lines_have";
				ps = conn.prepareStatement(query);
			}
			
			
			//print query for debugging
		    out.println("<b>[DEBUG] ps.toString():</b> "+ ps.toString());

			//execute query
		    try{
			    rs = ps.executeQuery();
		    
				// If there are results, display them in a table
				if(rs.next()){
				%>
				<!-- Display Results in a Table -->
				
				<h2>Train Schedules:</h2>
				<table border="1" cellpadding="10">
					<tr>
						<th>Transit Line Name</th>
						<th>Train ID</th>
						<th>Origin</th>
						<th>Destination</th>
						<th>Arrival Time</th>
						<th>Departure Time</th>
						<th>Fare</th>
						<th>Number of Stops</th>
					</tr>
				<%
			        // Loop through all the rows in the result set
			    	do{
			    %>
					<tr>
						<td><%= rs.getString("transit_line_name") %></td>
						<td><%= rs.getString("train_id") %></td>
						<td><%= rs.getString("origin") %></td>
						<td><%= rs.getString("destination") %></td>
						<td><%= rs.getString("arrival") %></td>
						<td><%= rs.getString("departure") %></td>
						<td><%= rs.getDouble("fare") %></td>
						<td><%= rs.getInt("num_stops") %></td>
					</tr>
				<%
			      	} while(rs.next());
			    %>
				</table>
				
				<%
				}else{
					out.println("<h3>No train schedules found.</h3>");
				}
			
		    } catch(Exception e){
				out.println("Bad query. Please make sure you're using the right format.");
				//print exception for debugging
				out.println(e);
			}
		    %>
		    
			<!-- back to home link -->
		    <br>
			<h3 class="back-to-home">
				<a href="customerHome.jsp">Back to Home</a>
			</h3>
		<%
		}catch(Exception e){
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
		
		%>
<%
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
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
		
		Connection conn = null;
	    PreparedStatement ps = null;
	    ResultSet rs = null;
	    
		// try to connect to db
		try{
			ApplicationDB db = new ApplicationDB();
			conn = db.getConnection();
			
			//Grab action, origin, destination, dep date and time
			String action = (String) request.getParameter("action");
			String originStation = (String) request.getParameter("originStation");
			String destinationStation = (String) request.getParameter("destinationStation");
			String sortBy = (String) request.getParameter("sortBy"); 				
			String sortOrder = (String) request.getParameter("sortOrder");
			String dateOfTravel = (String) request.getParameter("dateOfTravel");
			String timeOfTravel = (String) request.getParameter("timeOfTravel");
			// out.println(depTime);
			out.println(sortBy);
			
			String query = "SELECT *, fare/num_stops fare_per_stop FROM transit_lines_have";
			ps = conn.prepareStatement(query);
			
			
			
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
						<th>Fixed Fare</th>
						<th>Number of Stops</th>
						<th>Fare Per Stop</th>
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
						<td>$<%= rs.getDouble("fare") %></td>
						<td><%= rs.getInt("num_stops") %></td>
						<td>$<%= rs.getDouble("fare_per_stop") %></td>
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
		    <div>
		<h2>
			Create Reservation
		</h2>
		<form method="post" action="reserve.jsp">
			<div class="flex-container">
				<span>
					<label for="transitName">Transit Line Name</label>
					<input id="transitName" name="transitName" required/>
				</span>
				<span>
					<label for="trainID">Train ID</label>
					<input id="trainID" name="trainID" required/>
				</span>
				<span>
					<label for="originStation">Origin Station</label>
					<input id="originStation" name="originStation" required/>
				</span>
				<span>
					<label for="destinationStation">Destination Station</label>
					<input id="destinationStation" name="destinationStation" required/>
				</span>
				<span>
					<label for="disabled"> None </label>
					<input id="disabled" type="radio" name="discount" value="none" checked/>
				</span>
				<span>
					<label for="child"> Senior</label>
					<input id="child" type="radio" name="discount" value="senior"/>
				</span>
				<span>
					<label for="child"> Child </label>
					<input id="child" type="radio" name="discount" value="child"/>
				</span>
				<span>
					<label for="disabled"> Disabled</label>
					<input id="disabled" type="radio" name="discount" value="disable"/>
				</span>
				<button type="submit"> Create </button>
			</div>
		</form>
	</div>
	<div>
		    
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
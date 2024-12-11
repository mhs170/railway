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
        text-align: center;
    }

    th {
        background-color: #f2f2f2;
    }

    td {
        text-align: center;
    }
    .form-actions{
    	margin: 5px;
    	margin-top: 10px;
    }
    fieldset{
		margin: 5px;    
    }
    
    h2{
    	margin-top:50px;
    }
</style>
</head>
<body>

<%
	String username = (String) session.getAttribute("username");
	if (username != null) {
		//Grab action, origin, destination, dep date and time
		String action = (String) request.getParameter("action");
		String originStation = (String) request.getParameter("originStation");
		String destinationStation = (String) request.getParameter("destinationStation");
		String sortBy = (String) request.getParameter("sortBy"); 				
		String sortOrder = (String) request.getParameter("sortOrder");
		String dateOfTravel = (String) request.getParameter("dateOfTravel");
		String timeOfTravel = (String) request.getParameter("timeOfTravel");
%>
<h1>Search Train Schedules</h1>

<div class="form-container">
    <form method="post" action="searchSchedule.jsp" onsubmit= "return validateForm(event)">
        <fieldset>
            <legend><b>Choose Search Filters:</b></legend>
            <div class="form-group">
                <label for="originStation">Origin Station:</label>
                <input id="originStation" type="text" name="originStation" value="<%= originStation != null ? originStation : "" %>" placeholder="Enter Origin" />
            </div>
            <div class="form-group">
                <label for="destinationStation">Destination Station:</label>
                <input id="destinationStation" type="text" name="destinationStation" value="<%= destinationStation != null ? destinationStation : "" %>" placeholder="Enter Destination" />
            </div>
            <div class="form-group">
                <label for="dateOfTravel">Date of Travel:</label>
                <input id="dateOfTravel" type="date" name="dateOfTravel" value="<%= dateOfTravel != null ? dateOfTravel : "" %>" />
            </div>
            <div class="form-group">
                <label for="timeOfTravel">Time of Travel:</label>
                <input id="timeOfTravel" type="time" name="timeOfTravel" value="<%= timeOfTravel != null ? timeOfTravel : "" %>" />
                <button type="button" onclick="clearTimeField()">Clear</button>
            </div>
            <!-- Here -->
        </fieldset>

        <fieldset>
            <legend><b>Choose Sorting Options:</b></legend>
            <div class="form-group">
                <label for="sortBy">Sort By:</label>
                <select name="sortBy" id="sortBy">
				   <option value="transit_line_name" <%= "transit_line_name".equals(sortBy) ? "selected" : "" %>>Transit Line Name</option>
				   <option value="train_id" <%= "train_id".equals(sortBy) ? "selected" : "" %>>Train ID</option>
				   <option value="origin" <%= "origin".equals(sortBy) ? "selected" : "" %>>Origin</option>
				   <option value="destination" <%= "destination".equals(sortBy) ? "selected" : "" %>>Destination</option>
				   <option value="arrival" <%= "arrival".equals(sortBy) ? "selected" : "" %>>Arrival Time</option>
				   <option value="departure" <%= "departure".equals(sortBy) ? "selected" : "" %>>Departure Time</option>
				   <option value="fare" <%= "fare".equals(sortBy) ? "selected" : "" %>>Fare</option>
				   <option value="num_stops" <%= "num_stops".equals(sortBy) ? "selected" : "" %>>Number of Stops</option>
				</select>
            </div>
            <div class="form-group">
               	<label for="sortOrder">Order:</label>
				<select name="sortOrder" id="sortOrder">
			    	<option value="ASC" <%= "ASC".equals(sortOrder) ? "selected" : "" %>>Ascending</option>
			    	<option value="DESC" <%= "DESC".equals(sortOrder) ? "selected" : "" %>>Descending</option>
				</select>
            </div>
        </fieldset>

        <div class="form-actions">
            <button type="submit" name="action" value="search">Search</button>
            <button type="submit" name="action" value="viewAll">View All</button>
        </div>
    </form>
    <script>
	    function validateForm(event) {
	        const action = event.submitter.value; // Get which button was clicked
	        if (action === "search") {
	            const date = document.getElementById("dateOfTravel").value.trim();
	            const time = document.getElementById("timeOfTravel").value.trim();
	            if (time && !date){
	            	alert("Cannot provide time with no date.");
               		return false; // Prevent form submission
	            }
	        }
	        // No validation required for "View All"
	        return true;
	    }
	    function clearTimeField() {
	        const timeInput = document.getElementById('timeOfTravel');
	        if (timeInput) {
	            timeInput.value = ''; // Clear the field
	        }
	    }
	</script>
</div>
<% 
    	Connection conn = null;
	    PreparedStatement ps = null;
	    ResultSet rs = null;
	    
		// try to connect to db
		try{
			ApplicationDB db = new ApplicationDB();
			conn = db.getConnection();
			// out.println(depTime);
			
			if(action == null){
				//first visit
				
				String query = "SELECT *, fare/num_stops fare_per_stop FROM transit_lines_have ORDER BY transit_line_name ASC";
				ps = conn.prepareStatement(query);
			}else if(action.equals("viewAll")){
				//user pressed View All 
				
				String query = "SELECT *, fare/num_stops fare_per_stop FROM transit_lines_have ORDER BY " + sortBy + " " + sortOrder;
				ps = conn.prepareStatement(query);
			}else if(action.equals("search")){
				//user pressed search
				
				String query = "SELECT *, fare/num_stops fare_per_stop FROM transit_lines_have";
				boolean andCheck = false;
				if(!originStation.equals("") || !destinationStation.equals("") || !dateOfTravel.equals("") || !timeOfTravel.equals("")){
					//user entred some condition
					query += " WHERE";
					
					//get origin if it isn't empty
					if(!originStation.equals("")){
						query += " origin = '"+ originStation + "'";
						andCheck = true;
					}
					
					//get dest if it isn't empty
					if(!destinationStation.equals("")){
						if(andCheck){
							query += " AND";
						}
						query += " destination = '"+ destinationStation + "'";
						andCheck = true;
					}
					
					//get date/time if it isn't empty
					if(!dateOfTravel.equals("") && !timeOfTravel.equals("")){
						//user entered both date and time
						if(andCheck){
							query += " AND";
						}
						query += " '" + dateOfTravel + " " + timeOfTravel + "' BETWEEN departure AND arrival";
					}else if(!dateOfTravel.equals("")){
						//user entered only date
						if(andCheck){
							query += " AND";
						}
						query += " '"+ dateOfTravel + "' BETWEEN DATE(departure) AND DATE(arrival)";
						
					}
					
					
				
				}
					query += " ORDER BY " + sortBy + " " + sortOrder;
					ps = conn.prepareStatement(query);
			}
			
			
			
			//print query for debugging
		    //out.println("<b>[DEBUG] ps.toString():</b> "+ ps.toString());

			//execute query
		    try{
			    rs = ps.executeQuery();
		    
				// If there are results, display them in a table
				if(rs.next()){
				%>
				<!-- Display Results in a Table -->
				
				<h2>Search Results:</h2>
				<table border="1" cellpadding="10">
					<tr>
						<th>Transit Line Name</th>
						<th>Train ID</th>
						<th>Origin</th>
						<th>Destination</th>
						<th>Departure Time (from Origin)</th>
						<th>Arrival Time (at Destination)</th>
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
						<td><%= rs.getString("departure") %></td>
						<td><%= rs.getString("arrival") %></td>
						<td>$<%= rs.getDouble("fare") %></td>
						<td><%= rs.getInt("num_stops") %></td>
						<td>$<%= String.format("%.2f", rs.getDouble("fare_per_stop"))  %></td>
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
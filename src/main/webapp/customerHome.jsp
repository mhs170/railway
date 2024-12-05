<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ page import="com.cs336.pkg.ApplicationDB"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Customer Home Page</title>
<style>
	.schedule-form-container {
	    display: flex;
	    flex-direction: column; /* Arrange children vertically */
	}
</style>
</head>
<body>
	<% 
	String username = (String) session.getAttribute("username");
    if (username != null) {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<String> stops = new ArrayList<String>();
        List<String> times = new ArrayList<String>();
        List<String> transitLineNames = new ArrayList<String>();
        try {
        	ApplicationDB db = new ApplicationDB();
        	conn = db.getConnection();
            
        	// fill stops
            stmt = conn.prepareStatement("SELECT DISTINCT station_name FROM stations ORDER BY station_name");
            rs = stmt.executeQuery();
            while (rs.next()) {
                stops.add(rs.getString("station_name"));
            }
            rs.close();
            stmt.close();
            
            //fill times
            stmt = conn.prepareStatement("SELECT DISTINCT departure FROM transit_lines_have ORDER BY departure");
            rs = stmt.executeQuery();
            while (rs.next()) {
                times.add(rs.getString("departure"));
            }
            rs.close();
	        stmt.close();
            
            //fill transitLineNames
            stmt = conn.prepareStatement("SELECT DISTINCT transit_line_name FROM transit_lines_have ORDER BY transit_line_name");
	        rs = stmt.executeQuery();
	        while (rs.next()) {
	        	transitLineNames.add(rs.getString("transit_line_name"));
	        }
	        
            
            
        } catch (Exception e) {
            out.println("<p>Error: " + e.getMessage() + "</p>");
        } finally {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        }
%>
    <h1 class="title">
		Train Reservation System
	</h1>
    <div style="text-align: center;">
        <h1>Welcome, <%= username %>!</h1>
        <form action="logout.jsp" method="post">
            <button type="submit">Logout</button>
        </form>
    </div>
 

<!--  Search for train schedules by origin, destination, and/or date of travel-->
<div>
	<h2 >Search for Train Schedules</h2>
	
	<form method="post" action="searchSchedule.jsp" onsubmit="return validateForm(event)">
		<!-- Input information -->
		<div class="schedule-form-container">
	    	<span>
	      		<label for="originStation" > Origin Station</label>
	      		<input id="originStation" type='text' name="originStation" placeholder="Enter Origin"/>
	    	</span>
	    	<span>
	      		<label for="destinationStation" > Destination Station</label>
	      		<input id="destinationStation" type='text' name="destinationStation" placeholder="Enter Destination"/>
	    	</span>
	    	<span>
	      		<label for="dateOfTravel" >Date Of Travel (not required)</label>
	      		<input id="dateOfTravel" type='date' name="dateOfTravel" placeholder="YYYY-MM-DD"/>
	    	</span>
	    	<span>
	      		<label for="timeOfTravel" >Time of Travel (not required)</label>
	      		<input id="timeOfTravel" type='text' name="timeOfTravel" placeholder="HH:MM:SS"/>
	    	</span>
	  	</div>
	  	
        <!-- Sorting Options -->
	  	<div>
            <span>
                <label for="sortBy">Sort By</label>
                <select name="sortBy" id="sortBy">
                    <option value="transit_line_name">Transit Line Name</option>
                    <option value="train_id">Train ID</option>
                    <option value="origin">Origin</option>
                    <option value="destination">Destination</option>
                    <option value="arrival">Arrival Time</option>
                    <option value="departure">Departure Time</option>
                    <option value="fare">Fare</option>
                    <option value="num_stops">Number of Stops</option>
                </select>
            </span>
            <span>
                <label for="sortOrder">Order</label>
                <select name="sortOrder" id="sortOrder">
                    <option value="ASC">Ascending</option>
                    <option value="DESC">Descending</option>
                </select>
            </span>
        </div>
	  	<button type="submit" name="action" value="search"> Search</button>
	  	<button type="submit" name="action" value="viewAll"> View All Schedules</button>
	</form>
	<script>
	    function validateForm(event) {
	        const action = event.submitter.value; // Get which button was clicked
	        if (action === "search") {
	            const origin = document.getElementById("originStation").value.trim();
	            const destination = document.getElementById("destinationStation").value.trim();
	            if (!origin || !destination) {
                	alert("Origin and Destination are required for searching schedules.");
	                return false; // Prevent form submission
	            }
	            
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
	</script>
</div>

<!-- view all stops of a specific transit line -->
<div>
	<h2>View Stops by Transit Line</h2>
	<!-- 
	- drop down menu
	- pick a transit
	- pick a way to sort it
	- redirect to a page that displays it; searchByTransit.jsp
	 -->
	 <form method="post" action="searchStopsByTransit.jsp">
        <div>
            <label for="transitLine">By Transit Line: </label>
          	<select id="transitLine" name="transitLine" required>
                 <option value="" disabled selected>Select Transit Line</option>
                 <% for (String name : transitLineNames) { %>
                     <option value="<%= name %>"><%= name %></option>
                 <% } %>
           	</select>
        </div>
        <div>
            <label for="sortBy">Sort By:</label>
            <select name="sortBy" id="sortBy" required>
                <option value="arrivalASC">Arrival Time (ascending order)</option>
                <option value="arrivalDESC">Arrival Time (descending order)</option>
                <option value="departureASC">Departure Time (ascending order)</option>
                <option value="departureDESC">Departure Time (descending order)</option>
            </select>
        </div>
        <button type="submit">View Stops</button>
    </form>
    
	
</div>	

<!-- TODO: Create, view, and cancel reservations -->
<div>
<div>
				<h2>
					Create Reservation
				</h2>
					To create a reservation, please click <a href="makeReservation.jsp">here</a>.
			</div>
</div>

<div>
<h2 >View Your Reservations</h2>
<form action="reservationPortfolio.jsp" method="get">
        <button type="submit">View</button>
    </form>
</div>

<!-- TODO: browse, search for, and ask questions -->

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
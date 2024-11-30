<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
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
	      		<label for="depDate" >Departure Date</label>
	      		<input id="depDate" type='text' name="depDate" placeholder="YYYY-MM-DD"/>
	    	</span>
	    	<span>
	      		<label for="depTime" >Departure Time (not required)</label>
	      		<input id="depTime" type='text' name="depTime" placeholder="HH:MM:SS"/>
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
            <!-- Dropdown for Transit Lines -->
            <label for="transitLine">Choose a Transit Line:</label>
            <select name="transitLine" id="transitLine" required>
                <option value="" disabled selected>Select a Transit Line</option>
                <option value="test">Test Line</option>
                <option value="NJTransit">NJ Transit</option>
                <option value="randomLine">Random Line</option>
            </select>
        </div>
        <div>
            <!-- Sorting Options -->
            <label for="sortBy">Sort By:</label>
            <select name="sortBy" id="sortBy" required>
            <!-- TODO: value should be the actual attribute name in the table?? -->
                <option value="arrivalASC">Arrival Time (ascending order)</option>
                <option value="arrivalDESC">Arrival Time (descending order)</option>
                <option value="departureASC">Departure Time (ascending order)</option>
                <option value="departureDESC">Departure Time (descending order)</option>
            </select>
        </div>
        <!-- Submit Button -->
        <button type="submit">View Stops</button>
    </form>
    
	
</div>	

<!-- TODO: Create, view, and cancel reservations -->
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

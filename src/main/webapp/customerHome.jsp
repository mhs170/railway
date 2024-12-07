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
<!-- 
 - button: click here to search for a train schedule
 	- redirect to searchSchedule (with viewAll)
 - make searchSchedule similar to makeReservation.jsp
 	- have input fields inline for origin, dest, date of travel, time of travel, and sortBy and orderBy
 		- make at least one field required
 	- display all train schedules at the bottom
 	- when user hits "search" refresh page (with their search
 	- also add view all button
 -->
<div>
	<h2 >Search for Train Schedules</h2>
	
		To search for train schedules, please click <a href="searchSchedule.jsp">here</a>.
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
                <option value="stop_time">Time </option>
                <option value="station_id">Station ID</option>
                <option value="station_name">Station Name</option>
                <option value="city">City</option>
                <option value="state_abb">State</option>
            </select>
        </div>
        <div>
            <label for="order">Order:</label>
            <select name="order" id="order" required>
                <option value="ASC">Ascending </option>
                <option value="DESC">Descending</option>
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

<h2>Ask a Question</h2>
<form method="post" action="forum.jsp">
  <label for="question">Question:</label>
  <input type="text" id="question" name="question" size="40" required>
  <button type="submit">Submit</button>
</form>

<div>
<form action="questionsList.jsp" method="get">
        <button type="submit">View Forum</button>
</form>
</div>

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
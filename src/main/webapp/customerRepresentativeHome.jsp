<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- imports -->
<%@ page import="com.cs336.pkg.ApplicationDB" %>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<% 
    String username = (String) session.getAttribute("username");
    if (username != null) {
    		
    	Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
	 	List<Integer> stationIDs = new ArrayList<Integer>();
	 	List<String> stationNames = new ArrayList<String>();
	 	List<Integer> trains = new ArrayList<Integer>();
	 	List<String> transitLineNames = new ArrayList<String>();
	 	try {
        	ApplicationDB db = new ApplicationDB();
        	conn = db.getConnection();
            
        	// fill stationIDs
            stmt = conn.prepareStatement("SELECT DISTINCT station_id FROM stations ORDER BY station_id");
            rs = stmt.executeQuery();
            while (rs.next()) {
                stationIDs.add(rs.getInt("station_id"));
            }
            rs.close();
            stmt.close();
            
            // fill stationNames
            stmt = conn.prepareStatement("SELECT DISTINCT station_name FROM stations ORDER BY station_name");
            rs = stmt.executeQuery();
            while (rs.next()) {
                stationNames.add(rs.getString("station_name"));
            }
            rs.close();
            stmt.close();
           
            
         	// fill trains
            stmt = conn.prepareStatement("SELECT DISTINCT train_id FROM trains ORDER BY train_id");
            rs = stmt.executeQuery();
            while (rs.next()) {
                trains.add(rs.getInt("train_id"));
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
    <div style="text-align: center;">
    	<h1>Customer Rep page</h1>
        <h1>Welcome, <%= username %>!</h1>
        <form action="logout.jsp" method="post">
            <button type="submit">Logout</button>
        </form>
    </div>


<div>
<h2>Add Train</h2>
<form method="post" action="createTrain.jsp">
  <label for="train_id">Train ID:</label>
  <input type="text" id="train_id" name="train_id" required>
  <button type="submit">Create</button>
</form>
</div>

<div>
<h2>Add Station</h2>

<form method="post" action="createStation.jsp">
  <label for="station_id">Station ID:</label>
  <input type="text" id="station_id" name="station_id" required>
  <label for="station_name">Station Name:</label>
  <input type="text" id="station_name" name="station_name" required>
  <label for="station_city">Station City:</label>
  <input type="text" id="station_city" name="station_city" required>
  <label for="state">State:</label>
  <input type="text" id="state" name="state" required>
 
  <button type="submit">Create</button>
</form>
</div>

<div>
<h2>Add Stop</h2>
<form method="post" action="createStop.jsp">
  <label for="transit_line_name">Transit Line: </label>
  <select id="transit_line_name" name="transit_line_name" required>
   		<option value="" disabled selected>Select Transit Line</option>
	<% for (String name : transitLineNames) { %>
	    <option value="<%= name %>"><%= name %></option>
	<% } %>
  </select>
  
  <label for="stationID">Station  ID: </label>
  <select id="stationID" name="stationID" required>
   		<option value="" disabled selected>Select Station ID</option>
	<% for (Integer sid : stationIDs) { %>
	    <option value="<%= sid %>"><%= sid %></option>
	<% } %>
  </select>
  
  <label for="stop_time">Stop Time:</label>
  <input type="text" id="stop_time" name="stop_time" placeholder="hh:mm:ss" required>
 
  <button type="submit">Create</button>
</form>
</div>

<div>
<h2>Add Schedule</h2>
<form method="post" action="createSchedule.jsp">
  <label for="transitLineName">Transit Line:</label>
  <input type="text" id="transitLineName" name="transitLineName" required>
  <label for="trainID">Train ID:</label>
  <select id="trainID" name="trainID" required>
   		<option value="" disabled selected>Select Train ID</option>
	<% for (Integer tid : trains) { %>
	    <option value="<%= tid %>"><%= tid %></option>
	<% } %>
  </select>
   
  <label for="origin">Origin Station: </label>
  <select id="origin" name="origin" required>
   		<option value="" disabled selected>Select Origin Station</option>
	<% for (String name : stationNames) { %>
	    <option value="<%= name %>"><%= name %></option>
	<% } %>
  </select>
  
  <label for="destination">Destination Station:</label>
  <select id="destination" name="destination" required>
   		<option value="" disabled selected>Select Destination Station</option>
	<% for (String name : stationNames) { %>
	    <option value="<%= name %>"><%= name %></option>
	<% } %>
  </select>
  
  <label for="departure">Departure Date and Time:</label>
  <input type="text" id="departure" name="departure" placeholder="yyyy:mm:dd hh:mm:ss"  required>
  <label for="arrival">Arrival Date and Time:</label>
  <input type="text" id="arrival" name="arrival" placeholder="yyyy:mm:dd hh:mm:ss"  required>
  <label for="fare">Fixed Fare:</label>
  <input type="text" id="fare" name="fare" required>
  <label for="num_stops">Number of Stops:</label>
  <input type="text" id="num_stops" name="num_stops" required>
  
  <button type="submit">Create</button>
</form>
</div>

<div>
<h2>Edit Schedule</h2>
<form method="post" action="editSchedule.jsp">
  <label for="line_name">Transit Line:</label>
  <select id="line_name" name="line_name" required>
   		<option value="" disabled selected>Select Transit Line</option>
	<% for (String name : transitLineNames) { %>
	    <option value="<%= name %>"><%= name %></option>
	<% } %>
  </select>
  <button type="submit">Edit</button>
</form>
</div>

<div>
<h2>Delete Schedule</h2>
<form method="post" action="deleteSchedule.jsp" onsubmit="return confirm('Are you sure you want to delete this schedule?');">
  <label for="transit_line_name">Transit Line:</label>
  <select id="transit_line_name" name="transit_line_name" required>
   		<option value="" disabled selected>Select Transit Line</option>
	<% for (String name : transitLineNames) { %>
	    <option value="<%= name %>"><%= name %></option>
	<% } %>
  </select>
  <button type="submit">Delete</button>
</form>
</div>


<div>
<h2>Answer a Question</h2>
<form action="answerQuestion.jsp" method="get">
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
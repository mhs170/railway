<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- imports -->
<%@ page import="com.cs336.pkg.ApplicationDB" %>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<% 
    String username = (String) session.getAttribute("username");
    if (username != null) {
%>
    <div style="text-align: center;">
    	<h1>Customer Rep page</h1>
        <h1>Welcome, <%= username %>!</h1>
        <form action="logout.jsp" method="post">
            <button type="submit">Logout</button>
        </form>
    </div>
<% 
    } else { 
%>
    <div style="text-align: center;">
        <h1>You are not logged in!</h1>
    </div>
<%
    }
%>

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
  <label for="transit_line_name">Transit Line:</label>
  <input type="text" id="transit_line_name" name="transit_line_name" required>
  <label for="stationID">Station ID:</label>
  <input type="text" id="stationID" name="stationID" required>
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
  <input type="text" id="trainID" name="trainID" required>
  <label for="origin">Origin Station:</label>
  <input type="text" id="origin" name="origin" required>
  <label for="destination">Destination Station:</label>
  <input type="text" id="destination" name="destination" required>
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
  <input type="text" id="line_name" name="line_name" required>
  <button type="submit">Edit</button>
</form>
</div>

<div>
<h2>Delete Schedule</h2>
<form method="post" action="deleteSchedule.jsp" onsubmit="return confirm('Are you sure you want to delete this schedule?');">
  <label for="transit_line_name">Transit Line:</label>
  <input type="text" id="transit_line_name" name="transit_line_name" required>
  <button type="submit">Delete</button>
</form>
</div>


<div>
<h2>Answer a Question</h2>
<form action="answerQuestion.jsp" method="get">
        <button type="submit">View Forum</button>
</form>
</div>
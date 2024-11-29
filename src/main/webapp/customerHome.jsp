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
	
	<form method="post" action="searchSchedule.jsp">
		<div class="schedule-form-container">
	    	<span>
	      		<label for="originStation" > Origin Station</label>
	      		<input id="originStation" type='text' name="originStation" required/>
	    	</span>
	    	<span>
	      		<label for="destinationStation" > Destination Station</label>
	      		<input id="destinationStation" type='text' name="destinationStation" required/>
	    	</span>
	    	<span>
	      		<label for="depDate" >Departure Date</label>
	      		<input id="depDate" type='text' name="depDate" placeholder="YYYY-MM-DD" required/>
	    	</span>
	    	<span>
	      		<label for="depTime" >Departure Time (not required)</label>
	      		<input id="depTime" type='text' name="depTime" placeholder="HH:MM:SS"/>
	    	</span>
	  	</div>
	  	<button type="submit"> Search</button>
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

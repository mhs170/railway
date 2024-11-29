<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- imports -->
<%@ page import="com.cs336.pkg.ApplicationDB" %>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
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
		// Grab origin, destination, and date
		String originStation = (String) request.getParameter("originStation");
		String destinationStation = (String) request.getParameter("destinationStation");
		String depDate = (String) request.getParameter("depDate");
		String depTime = (String) request.getParameter("depTime");
		// out.println(depTime);
		
		Connection conn = null;
	    PreparedStatement ps = null;
	    ResultSet rs = null;
	    
		// try to connect to db
		try{
			ApplicationDB db = new ApplicationDB();
			conn = db.getConnection();
			
			//create query
			String query = "";
			if(!depDate.equals("") && !depTime.equals("")){
				//user entered both date and time
				query = "SELECT * FROM transit_lines_have WHERE origin = ? AND destination = ? AND departure = ?";
				ps = conn.prepareStatement(query);
			    ps.setString(1, originStation);
			    ps.setString(2, destinationStation);
			    ps.setString(3, depDate + depTime);
			}else {
				//user entered only date
				query = "SELECT * FROM transit_lines_have WHERE origin = ? AND destination = ? AND DATE(departure) = ?";
				ps = conn.prepareStatement(query);
			    ps.setString(1, originStation);
			    ps.setString(2, destinationStation);
			    ps.setString(3, depDate);
			}
			
			//print query for debugging
		    out.println("ps.toString(): "+ ps.toString());
		    %>
		    <br><br>
		    <%
		    
		    //execute query
		    try{
			    rs = ps.executeQuery();
		    
			// If there are results, display them in a table
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
		        while(rs.next()) {
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
		        }
		    %>
			</table>
			
			<%
		    } catch(Exception e){
				out.println("Bad query. Please make sure you're using the right format.");
				//print exception for debugging
				out.println(e);
			}
		    %>
			<!-- back to home link -->
		    <br>
			<h3>
				<a href="customerHome.jsp">Back to Home</a>
			</h3>
		<%
		}catch(Exception e){
			out.println("ERROR: Could not connect to the database");
			out.println(e);
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
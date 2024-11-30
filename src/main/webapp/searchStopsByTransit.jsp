<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- imports -->
<%@ page import="com.cs336.pkg.ApplicationDB" %>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title> Search Stops By Transit</title>
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
		//Grab transit name and sortBy
		String transitName = (String) request.getParameter("transitLine");
		String sortBy = (String) request.getParameter("sortBy");
		
		Connection conn = null;
	    PreparedStatement ps = null;
	    ResultSet rs = null;
	    
		// try to connect to db
		try{
			ApplicationDB db = new ApplicationDB();
			conn = db.getConnection();				
			
			//create query 
			String query = "SELECT * FROM stops WHERE transit_line_name = ? ORDER BY ?";
			ps = conn.prepareStatement(query);
			ps.setString(1, transitName);
			
			if(sortBy.equals("arrivalASC")){
				ps.setString(2, "stop_arrival ASC");
				
			}else if(sortBy.equals("arrivalDESC")){
				ps.setString(2, "stop_arrival DESC");
				
			}else if(sortBy.equals("departureASC")){
				ps.setString(2, "stop_departure ASC");
				
			}else if(sortBy.equals("departureDESC")){
				ps.setString(2, "stop_departure DESC");
				
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
				
					<h2> <%out.println(transitName);%> Stops</h2>
					<table border="1" cellpadding="10">
						<tr>
							<th>Transit Line Name</th>
							<th>Station ID</th>
							<th>Stop Arrival</th>
							<th>Stop Departure</th>
						</tr>
					<%
				        // Loop through all the rows in the result set
				    	do{
				    %>
						<tr>
							<td><%= rs.getString("transit_line_name") %></td>
							<td><%= rs.getString("station_id") %></td>
							<td><%= rs.getString("stop_arrival") %></td>
							<td><%= rs.getString("stop_departure") %></td>
						</tr>
					<%
				      	} while(rs.next());
				    %>
					</table>
				
				<%
				}else{
					out.println("<h3>No train stops found.</h3>");
				}
			
		    } catch(Exception e){
				out.println("Bad query.");
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
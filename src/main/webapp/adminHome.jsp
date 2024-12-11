<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Admin Home Page</title>
<style>
    .table-container {
        width: 50%; /* Set the container width to make the table smaller */
        margin: 0 auto; /* Center the container on the page */
        overflow-x: auto; /* Enable horizontal scrolling for small screens if needed */
    }
    table {
        width: 60%; /* Reduce table width */
        margin: auto; /* Center the table */
        border-collapse: collapse; /* Remove double borders */
        font-size: 14px; /* Reduce font size */
        }
    th, td {
        padding: 8px; /* Reduce padding */
        text-align: left;
    }
    th {
        background-color: #f2f2f2; /* Add a subtle background for headers */
    }
    tr:nth-child(even) {
        background-color: #f9f9f9; /* Alternate row colors for readability */
    }
    .inline-forms {
        display: flex;
        align-items: center;
        gap: 20px; /* Adjust spacing between forms */
    }
    .best-customer{
    	margin-top: 5px;
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
	    List<String> transitLineNames = new ArrayList<String>();
	    List<List<String>> customers = new ArrayList<List<String>>();
	    	// basically stores 2-tuples, a (username, real-name) pair, where real name is "l_name, f_name"
	    Map<String, Object> bestCustomer = new HashMap<String, Object>();
	    	// best customer: need f_name, l_name, total revenue
	    List<Map<String, Object>> top5TransitLines = new ArrayList<Map<String, Object>>();
	    try {
	    	ApplicationDB db = new ApplicationDB();
	    	conn = db.getConnection();
	        
	        stmt = conn.prepareStatement("SELECT DISTINCT transit_line_name FROM transit_lines_have ORDER BY transit_line_name");
	        rs = stmt.executeQuery();
	        while (rs.next()) {
	        	transitLineNames.add(rs.getString("transit_line_name"));
	        }
	        rs.close();
	        stmt.close();
	        
	        
	        stmt = conn.prepareStatement("SELECT username, l_name, f_name FROM users JOIN customers using(username) ORDER BY l_name");
	        rs = stmt.executeQuery();
	        while (rs.next()) {
	        	//create a (username, real-name) pair
	        	//add that to the array list.
	        	//having the username helps with the db lookups in getRevenuePerCustomer.jsp
	        	ArrayList<String> pair1 = new ArrayList<String>();
	            pair1.add(rs.getString("username"));
	            pair1.add(rs.getString("l_name") + ", " + rs.getString("f_name"));
	            customers.add(pair1);
	            
	        } 
	        rs.close();
	        stmt.close();
	        
	       	//get best customer
	        String query = 	"SELECT username, l_name, f_name,  total_rev " +
							"FROM (	SELECT username, l_name, f_name, sum(total_fare) total_rev "+
        							"FROM users "+
        							"JOIN reservations USING(username) " +
        							"GROUP BY username, l_name, f_name " +
        							"ORDER BY l_name"+
									") t "+
        					"ORDER BY total_rev DESC "+
							"LIMIT 1";
	        stmt = conn.prepareStatement(query);
	        rs = stmt.executeQuery();
	        while (rs.next()) {
	        	//get best customer's info
	        	bestCustomer.put("username", rs.getString("username"));
	        	bestCustomer.put("l_name", rs.getString("l_name"));
	        	bestCustomer.put("f_name", rs.getString("f_name"));
	        	bestCustomer.put("total_rev", rs.getDouble("total_rev"));
	            
	        }
	        rs.close();
	        stmt.close();
	        
	        //get top 5 transit lines
	        query = "SELECT transit_line_name, MONTH(date) AS reservation_month, YEAR(date) AS reservation_year, COUNT(*) AS reservations_count " +
	        		"FROM reservations " +
	        		"JOIN has_transit USING(username, res_number) " +
	        		"GROUP BY transit_line_name, YEAR(date), MONTH(date) " +
	        		"ORDER BY reservations_count DESC " +
	        		"LIMIT 5";
	        stmt = conn.prepareStatement(query);
	        rs = stmt.executeQuery();
	        while (rs.next()) {
				
	        	Map<String, Object> thisTransitLine = new HashMap<String, Object>();
	        	
	        	thisTransitLine.put("transit_line_name", rs.getString("transit_line_name"));
	        	thisTransitLine.put("reservation_month", rs.getString("reservation_month"));
	        	thisTransitLine.put("reservation_year", rs.getString("reservation_year"));
	        	thisTransitLine.put("reservations_count", rs.getString("reservations_count"));
	        	
	        	top5TransitLines.add(thisTransitLine);
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
    	<h1>Admin page</h1>
        <h1>Welcome, <%= username %>!</h1>
        <form action="logout.jsp" method="post">
            <button type="submit">Logout</button>
        </form>
    </div>
    
    
    
    <!-- add, edit, delete information about a customer representative -->
    <div>
    	<h2>Manage Customer Representatives</h2>
    	
    	<h3>Search For Representative</h3>
    	<!-- search for reps. redirect to a table showing results with "Edit" and "Delete" options-->

    	<form method="post" action="searchCustomerReps.jsp" onsubmit="return validateForm(event)">
			<!-- Input information -->
			<div>
		    	<span>
		      		<label for="username">Username</label>
		      		<input id="custRepUsername" type='text' name="custRepUsername" placeholder="Enter Username"/>
		    	</span>
		    	<span>
		      		<label for="ssn"> SSN</label>
		      		<input id="custRepSsn" type='text' name="custRepSsn" placeholder="Enter SSN"/>
		    	</span>
		  	</div>
		  	
		  	<button type="submit" name="action" value="search"> Search</button>
		  	<button type="submit" name="action" value="viewAll"> View All Representatives</button> <!-- sort option ? -->
		</form>
		
		<script>
			function validateForm(event) {
		        const action = event.submitter.value; // Get which button was clicked
		        if (action === "search") {
		            const username = document.getElementById("custRepUsername").value.trim();
		            const ssn = document.getElementById("custRepSsn").value.trim();
		            if (!username && !ssn) {
		                alert("Username or SSN are required for searching Customer Representatives.");
		                return false; // Prevent form submission
		            }
		        }
		        // No validation required for "View All"
			}
		</script>
		
    	<br>
    	
    	<h3>Create A New Customer Representative</h3>
    	<!-- "create new customer representative button -->
    	<form method="get" action="createCustomerRepAccount.jsp">
        	<button type="submit">Click Here to Create</button>
    	</form>
    	
    </div>
    
    <hr>
    
    <div>
		<h2>Manage Money</h2>
		
    	<h3>Obtain Sales Report</h3>
    <!-- obtain sales report:
    - input a month and year (date)
    - redirect to getSalesReport.jsp
    - sum all the "total_fare" of every reservation that with that date 
    -->
    
	    <div>
		    <form method="post" action="getSalesReport.jsp">
				<!-- Input information -->
		    	<span>
		      		<label for="month">By Month & Year:</label>
		      		<input id="month" type='month' name="month" required/>
		    	</span>
			  	<button type="submit" name="action" value="month_year"> Get Sales Report</button>
			</form>
			
			<form method="post" action="getSalesReport.jsp">
			  	<span>
		      		<label for="year">By Year Only:</label>
		      		<input id="year" type="number" name = "year" min="1900" max="2099" step="1" value="2024" required/>
		    	</span>
			  	<button type="submit" name="action" value="year"> Get Sales Report</button>
			</form>
		</div>
		<br>
		
		<!-- get listing of revenue: 
		- by transit line
			- get transit line name (query for it)
			- join has_transit and reservations on res_number
			- sum total_fare of all the reservations
		-->
		
		<h3>Obtain Revenue Listing</h3>
		<div class="inline-forms">
			<form method="post" action="getRevenuePerTransitLine.jsp">
				<!-- Input information -->
		    	<span>
	    	 		<label for="transit_line_name">By Transit Line: </label>
	               	<select id="transit_line_name" name="transit_line_name" required>
	                   <option value="" disabled selected>Select Transit Line</option>
	                   <% for (String name : transitLineNames) { %>
	                       <option value="<%= name %>"><%= name %></option>
	                   <% } %>
	               </select>
		    	</span>
		    	
			  	<button type="submit" name="action" value="search"> Get Revenue</button>
			</form>
			
			  	<!-- view all transit lines-->
			<form method="post" action="getRevenuePerTransitLine.jsp">
				<button type="submit" name="action" value="viewAll"> View Revenue for all Transit Lines</button>
			</form>
		</div>
		<!-- 
		- by customer:
			- get customer name (query for it up top to show in the list)
			- join customers and reservations on username
			- sum total_fare of all the reservations 
		 -->
		<div class="inline-forms">
			<form method="post" action="getRevenuePerCustomer.jsp">
				<!-- Input information -->
		    	<span>
		      		<label for="customer_name">By Customer: </label>
	               	<select id="customer_name" name="customer_username" required>
	                   <option value="" disabled selected>Select Customer</option>
	                   <% for (List<String> name : customers) { %>
	                       <option value="<%= name.get(0) %>"><%= name.get(1) %></option>
	                       <!-- pass username to getRevenuePerCustomer.jsp, but display real name -->
	                   <% } %>
	               </select>
		    	</span>
			  	<button type="submit" name="action" value="search"> Get Revenue</button>
			</form>
			
		  	<!-- view all customers? -->
			<form method="post" action="getRevenuePerCustomer.jsp">
				<button type="submit" name="action" value="viewAll"> View Revenue for all Customers</button>
			</form>
		</div>
		
		<h3>Best Customer</h3>
		<div class="best-customer">
		<!-- e -->
			<%if(bestCustomer.isEmpty()){
						
			%>
				<div><b>There is currently no best customer because there are no sales :(</b></div>
			<%
			}else{
			%>
				<div><b>The current best customer is <%=bestCustomer.get("f_name")+ " "+ bestCustomer.get("l_name")  %>! They have spent $<%= String.format("%.2f", bestCustomer.get("total_rev")) %>!</b></div>
			<%
			}
			%>
			
		
		</div>
    </div>
    <hr>
    
    <div>
    <!-- 
    [] produce a list of reservations: (5 points)
	[] by transit line
	[] by customer name
	
	- input transit line
	- redirecct to getReservationsByTransit
    
    - input customerName
	- redirecct to getReservationsByTransit
     -->
    	<h2>Manage Reservations</h2>
    	
    	<h3>Obtain List of Reservations</h3>
		
		<div class="inline-forms">
			<form method="post" action="getReservationsByTransit.jsp">
				<!-- Input information -->
		    	<span>
		      		<label for="customer_name">By Transit Line: </label>
	               	<select id="transit_line_name" name="transit_line_name" required>
	                   <option value="" disabled selected>Select Transit Line</option>
	                   <% for (String name : transitLineNames) { %>
	                       <option value="<%= name %>"><%= name %></option>
	                   <% } %>
	               </select>
		    	</span>
			  	<button type="submit" name="action" value="search"> View Reservations</button>
			</form>
			
		  	<!-- view all customers? -->
			<form method="post" action="getReservationsByTransit.jsp">
				<button type="submit" name="action" value="viewAll"> View all Reservations by Transit Line</button>
			</form>
		</div>
		
    	<div class="inline-forms">
			<form method="post" action="getReservationsByCustomer.jsp">
				<!-- Input information -->
		    	<span>
		      		<label for="customer_name">By Customer: </label>
	               	<select id="customer_name" name="customer_username" required>
	                   <option value="" disabled selected>Select Customer</option>
	                   <% for (List<String> name : customers) { %>
	                       <option value="<%= name.get(0) %>"><%= name.get(1) %></option>
	                       <!-- pass username to getRevenuePerCustomer.jsp, but display real name -->
	                   <% } %>
	               </select>
		    	</span>
			  	<button type="submit" name="action" value="search"> View Reservations</button>
			</form>
			
		  	<!-- view all customers? -->
			<form method="post" action="getReservationsByCustomer.jsp">
				<button type="submit" name="action" value="viewAll"> View all Reservations by Customer</button>
			</form>
		</div>
		
		<h3>Top 5 Transit Lines (most reservations in any given month)</h3>
		<div class="table-container">
			<table border="1" cellspacing="0" cellpadding="5" style="width: 100%; text-align: left;">
		        <thead>
		            <tr>
		                <th>Transit Line Name</th>
		                <th>Reservations Count</th>
		                <th>Month</th>
		                <th>Year</th>
		            </tr>
		        </thead>
		        <tbody>
		            <% 
		            for(Map<String, Object> transit : top5TransitLines) {
		            %>
		            <tr>
		                <td><%= transit.get("transit_line_name") %></td>
		                <td><%= transit.get("reservations_count") %></td>
		                <td><%= transit.get("reservation_month") %></td>
		                <td><%= transit.get("reservation_year") %></td>
		            </tr>
		            <% 
		            }
		            %>
		        </tbody>
    		</table>
		</div>
		
    	
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

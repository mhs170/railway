<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- imports -->
<%@ page import="com.cs336.pkg.ApplicationDB" %>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Customer Representative Search Results</title>
</head>
<body>

<% 
    String username = (String) session.getAttribute("username");
    if (username != null) {
		/*  
		- get entered info
		- search for customer representative that matches the info
		- display them each (with first and last name from users table)
		- add 'edit' and 'delete' buttons next to them (use contact list project code)
		
		*/
		Connection conn = null;
	    PreparedStatement ps = null;
	    ResultSet rs = null;
	    
		// try to connect to db
		try{
			ApplicationDB db = new ApplicationDB();
			conn = db.getConnection();
			
			//Grab action, username, ssn
			String action = (String) request.getParameter("action");
			String custRepUsername = (String) request.getParameter("custRepUsername");
			String custRepSsn = (String) request.getParameter("custRepSsn");
			
			//create query
			if(action.equals("search")){
				//admin searched for a specific customer
				
				//join customer representatives table with users.
				//check what info admin provided (username, ssn, or both)
				
				String query = "SELECT username, ssn, f_name, l_name FROM customer_representatives JOIN users using(username) WHERE ";
				
				boolean hasUsername = !custRepUsername.equals("");
				boolean hasSsn = !custRepSsn.equals("");

				if (hasUsername) {
				    query += "username = ?";
				}
				if (hasSsn) {
				    if (hasUsername) {
				        // Add AND if username was already added
				        query += " AND ";
				    }
				    query += "ssn = ?";
				}
				ps = conn.prepareStatement(query);
				int paramIndex = 1;
				if (hasUsername) {
				    ps.setString(paramIndex++, custRepUsername);
				}
				if (hasSsn) {
				    ps.setString(paramIndex++, custRepSsn);
				}
				
			}else if(action.equals("viewAll")){
				//admin pressed view all customer reps
				String query = "SELECT username, ssn, f_name, l_name FROM customer_representatives JOIN users using(username) ORDER BY ssn ASC";
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
					
					<h2>Customer Representative Search Results:</h2>
					<table border="1" cellpadding="10">
						<tr>
							<th>Username</th>
							<th>SSN</th>
							<th>First Name</th>
							<th>Last Name</th>
							<th>Edit/Delete</th>
						</tr>
					<%
				        // Loop through all the rows in the result set
				    	do{
				    %>
						<tr>
							<td><%= rs.getString("username") %></td>
							<td><%= rs.getString("ssn") %></td>
							<td><%= rs.getString("f_name") %></td>
							<td><%= rs.getString("l_name") %></td>
							<td>
					        <!--  pass action to edit and delete so it can redirect back to this page by recreating the qeury-->
					        
								<!-- Inline form for Edit -->
							    <form action="editCustomerRep.jsp" method="post" style="display: inline;">
							        <input type="hidden" name="custRepUsername" value="<%= rs.getString("username") %>">
							        <input type="hidden" name="ssn" value="<%= rs.getString("ssn") %>">
							        <input type="hidden" name="f_name" value="<%= rs.getString("f_name") %>">
						           	<input type="hidden" name="l_name" value="<%= rs.getString("l_name") %>">
						           	
							        <input type="hidden" name="action" value="<%= action %>">
							        <button type="submit">Edit</button>
							    </form>
							    
							    <!-- Inline form for Delete -->
							    <form action="deleteCustomerRep.jsp" method="post" style="display: inline;" onsubmit="return confirm('Are you sure you want to delete this customer representative?');">
							        <input type="hidden" name="custRepUsername" value="<%= rs.getString("username") %>">
							        <input type="hidden" name="custRepSsn" value="<%= rs.getString("ssn") %>">
							        
							        <input type="hidden" name="action" value="<%= action %>">
      								<button type="submit">Delete</button>								
								</form>
							</td>
						</tr>
					<%
				      	} while(rs.next());
				    %>
					</table>
					
					
					<%
				}else{
					out.println("<h3>No customer representatives found.</h3>");
				}
			%>
					<form action="adminHome.jsp">
						<button>Back to Home</button>
	        		</form>
			<%	
				
				
			}catch(Exception e){
				out.println("Bad query.");
				//print exception for debugging
				out.println(e);
			}
			
			
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
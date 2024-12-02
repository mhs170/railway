<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Admin Home Page</title>
</head>
<body>
<% 
    String username = (String) session.getAttribute("username");
    if (username != null) {
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
		
		
    	<hr>
    	
    	<!-- "create new customer representative button -->
    	<form method="get" action="createCustomerRepAccount.jsp">
        	<button type="submit">Create New Customer Representative</button>
    	</form>
    	
    </div>
    	<h2>Obtain Sales Report</h2>
    <!-- obtain sales report:
    - input a month and year (date)
    - redirect to getSalesReport.jsp
    - sum all the "total_fare" of every reservation that with that date 
    -->
    
	    <form method="post" action="getSalesReport.jsp">
			<!-- Input information -->
	    	<span>
	      		<label for="month">Month & Year:</label>
	      		<input id="month" type='month' name="date" required/>
	    	</span>
		  	<button type="submit"> Get Sales Report</button>
		</form>
    <div>
    
    
    
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

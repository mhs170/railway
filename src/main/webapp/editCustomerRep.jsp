<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.cs336.pkg.ApplicationDB, java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Edit Customer Representative</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
        }
        .form-container {
            width: 400px;
            margin: auto;
        }
        label {
            display: block;
            margin-top: 10px;
        }
        input {
            width: 100%;
            padding: 8px;
            margin-top: 5px;
        }
        button {
            margin-top: 10px;
            padding: 10px 15px;
        }
    </style>
</head>
<body>
    <%
    	String username = (String) session.getAttribute("username");
    
    	String custRepUsername = (String) request.getParameter("custRepUsername");
    	String custRepSsn = (String) request.getParameter("ssn");
    	String f_name = (String) request.getParameter("f_name");
    	String l_name = (String) request.getParameter("l_name");
    	String action = (String) request.getParameter("action");
    		
		if (username != null) {
       	%>	
			<div class="form-container">
		      	<h2>Edit Customer Representative</h2>
		       		<form action="updateCustomerRep.jsp" method="post">
			            <label for="username">Username (cannot be changed):</label>
			            <input type="text" name="username" id="username" value="<%= custRepUsername %>" readonly>
			
			            <label for="ssn">SSN:</label>
			            <input type="text" name="ssn" id="ssn" value="<%= custRepSsn %>" required>
			
			            <label for="f_name">First Name:</label>
			            <input type="text" name="f_name" id="f_name" value="<%= f_name %>" required>
			
			            <label for="l_name">Last Name:</label>
			            <input type="text" name="l_name" id="l_name" value="<%= l_name %>" required>
						
						<!-- hidden inputs so updateCustomerRep.jsp can go back to searchCustomer.jsp -->
						<input type="hidden" name="action" value="<%= action %>">
			
			            <button type="submit">Update Representative</button>
			        </form>
			        <form action="searchCustomerReps.jsp" method="post">
			        	<input type="hidden" name="action" value="<%= action %>">
			        	<input type="hidden" name="custRepUsername" value="<%= custRepUsername %>">
			        	<input type="hidden" name="custRepSsn" value="<%= custRepSsn %>">
						<button>Back</button>
			        </form>
			</div>
		<%
			
		}else{
			%>
			<div style="text-align: center;">
	        <h1>You are not logged in! Please <a href="login.jsp">login</a> again. </h1>
	    	</div>
	    	<%
		}
	%>

</body>
</html>

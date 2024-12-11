<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="com.cs336.pkg.ApplicationDB" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Monthly Sales Report</title>
<style>
    body {
        font-family: Arial, sans-serif;
        background-color: #f9f9f9;
        color: #333;
        text-align: center;
        margin: 0;
        padding: 0;
    }
    .container {
        max-width: 600px;
        margin: 50px auto;
        background-color: #fff;
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        border-radius: 8px;
        padding: 20px;
    }
    table {
        width: 100%;
        border-collapse: collapse;
        margin: 20px 0;
    }
    th, td {
        border: 1px solid #ddd;
        padding: 10px;
        text-align: center;
    }
    th {
        background-color: #4CAF50;
        color: white;
    }
    td {
        font-size: 16px;
        color: #555;
    }
    a {
        color: #4CAF50;
        text-decoration: none;
    }
    a:hover {
        text-decoration: underline;
    }
    .back-to-home {
        margin-top: 20px;
    }
</style>
</head>
<body>
<% String username = (String) session.getAttribute("username");
    if (username != null) {
		
		Connection conn = null;
	    PreparedStatement ps = null;
	    ResultSet rs = null;
	    
		// try to connect to db
		try{
			ApplicationDB db = new ApplicationDB();
			conn = db.getConnection();
			
			String action = request.getParameter("action");
			
			if(action.equals("year")){
				//get year
				String year = request.getParameter("year");
				String query = "SELECT extract(MONTH FROM date) month, sum(total_fare) revenue FROM reservations WHERE DATE_FORMAT(date, '%Y') = ? GROUP BY month ORDER BY month";
				//make query, execute query, print result
				ps = conn.prepareStatement(query);
				ps.setString(1, year);
				try{
					rs = ps.executeQuery();
					double total =0;
					
					if(rs.next()){
		                %>
		                <div class="container">
		                    <table>
		                        <tr>
		                            <th>Month</th>
		                            <th>Total Monthly Revenue</th>
		                        </tr>
		                        
	                        <% 
	            	        // Loop through all the rows in the result set
		                        do{
									double revenue = rs.getDouble("revenue");
									total += revenue;
	                        %>	
		                        <tr>
		                            <td><%= rs.getString("month") %></td>
		                            <td>$<%= String.format("%.2f", revenue) %></td>
		                        </tr>
	                        <%	
		                        }while(rs.next());
                        	%>
	                        	<tr>
		                            <td><b>Total Revenue for <%= year %>:</b></td>
		                            <td><b>$<%= String.format("%.2f", total) %></b></td>
		                        </tr>
		                    </table>
		                </div>
		                <% 
		            } else { 
		                %>
		                <div class="container">
		                    <h3>No sales data found for the selected year.</h3>
		                </div>
		                <%
		            } 
				}catch(Exception e){
					out.println("Bad query. Please make sure you're using the right format.");
					//print exception for debugging
					out.println(e);
				}
				
			}else if(action.equals("month_year")){
				
				//get month
				String month = request.getParameter("month");
				String query = "SELECT sum(total_fare) revenue FROM reservations WHERE DATE_FORMAT(date, '%Y-%m') = ?";
				//make query, execute query, print result
				ps = conn.prepareStatement(query);
				ps.setString(1, month);
				try{
					rs = ps.executeQuery();
					
					if(rs.next()){
						double revenue = rs.getDouble("revenue");
		                %>
		                <div class="container">
		                    <table>
		                        <tr>
		                            <th>Month</th>
		                            <th>Total Revenue</th>
		                        </tr>
		                        <tr>
		                            <td><%= month %></td>
		                            <td>$<%= String.format("%.2f", revenue) %></td>
		                        </tr>
		                    </table>
		                </div>
		                <% 
		            } else { 
		                %>
		                <div class="container">
		                    <h3>No sales data found for the selected month.</h3>
		                </div>
		                <%
		            } 
				}catch(Exception e){
					out.println("Bad query. Please make sure you're using the right format.");
					//print exception for debugging
					out.println(e);
				}
			}
			    %>
		    
			<!-- back to home link -->
		    <br>
			<h3 class="back-to-home">
				<a href="adminHome.jsp">Back to Home</a>
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
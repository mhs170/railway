<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- imports -->
<%@ page import="com.cs336.pkg.ApplicationDB" %>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Schedule Search Results</title>
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
	String searchKeyword = request.getParameter("searchKeyword"); 

	
    if (username != null) {
		
		Connection conn = null;
		try{
			ApplicationDB db = new ApplicationDB();
			conn = db.getConnection();
			
			            String fetchQuery = "SELECT q.id AS question_id, q.body AS question_body, q.username AS question_username, " +
			                    "a.body AS answer_body, a.username AS answer_username " +
			                    "FROM posts q " +
			                    "LEFT JOIN posts a ON q.id = a.parent_id AND a.type = 'answer' " +
			                    "WHERE q.type = 'question'";
			            
			PreparedStatement fetchStmt;
			if (searchKeyword != null && !searchKeyword.trim().isEmpty()){
				fetchQuery += " AND q.body LIKE ?";
				fetchStmt = conn.prepareStatement(fetchQuery);
				fetchStmt.setString(1, "%" + searchKeyword + "%");
			}
			else{
				fetchStmt = conn.prepareStatement(fetchQuery);
			}
            ResultSet rs = fetchStmt.executeQuery();
%>

<h3>Search forum:</h3>
<form method="get" action="questionsList.jsp" style="display: inline-block;">
	<input type="text" name="searchKeyword" placeholder="Enter keyword" value="<%= searchKeyword != null ? searchKeyword : "" %>" />
	<button type="submit">Search</button>
</form>

    <table border="1">
        <thead>
            <tr>
                <th>Question ID</th>
                <th>Customer Username</th>
                <th>Question</th>
                <th>Answer</th>
                <th>Customer Representative Username</th>
            </tr>
        </thead>
        <tbody>
<%
            while (rs.next()) {
%>
            <tr>
                <td><%= rs.getInt("question_id") %></td>
                <td><%= rs.getString("question_username") %></td>
                <td><%= rs.getString("question_body") %></td>
                <td><%= rs.getString("answer_body") != null ? rs.getString("answer_body") : "No answer yet" %></td>
                <td><%= rs.getString("answer_username") != null ? rs.getString("answer_username") : "N/A" %></td>
            </tr>
<%
            }
            rs.close();
            fetchStmt.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
            out.println("<p>Error: " + e.getMessage() + "</p>");
        }
    } else {
        out.println("<p>Invalid question submission. Please fill out the form properly.</p>");
    }
%>
        </tbody>
    </table>
            
<div style="margin-top: 20px;">
    <a href="customerHome.jsp">
        <button type="button">Back to Home Page</button>
    </a>
</div>

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
<h2>Answer a Question</h2>
<form action="answerQuestion.jsp" method="get">
        <button type="submit">View Forum</button>
</form>
</div>
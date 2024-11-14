<% 
    String username = (String) session.getAttribute("username");
    if (username != null) {
%>
        <h1>Welcome, <%= username %>!</h1>
<% 
    } else { 
%>
        <h1>You are not logged in!</h1>
<%
    }
%>

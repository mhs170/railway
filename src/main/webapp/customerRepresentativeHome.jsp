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
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ page import="java.time.format.DateTimeFormatter,java.time.LocalDateTime"%>
<!DOCTYPE html>
<html>

<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Reservation Creation</title>
<link rel="stylesheet" href="home.css">
</head>
<body>
	<div>
		<% 
		try{
			session.getAttribute("username").equals("");
			}catch(Exception e){ 
				out.println("Invalid Session");
				out.println(e);
			%>	
				<div class="errorMessage">
					Your session has expired, please <a href="login.jsp">login</a> again. 
				</div>
			<% 	
				return;
			}
		%>
	</div>
	<h1 class="title">
		Train Reservation System
	</h1>
	
	<% 
	DateTimeFormatter dtf = DateTimeFormatter.ofPattern("yyyy-MM-dd");
	LocalDateTime now = LocalDateTime.now();
	String dateOfCreation = dtf.format(now);
	String username = (String) session.getAttribute("username");
	out.println(username);
	out.println(dateOfCreation); 
	
	String transitNames = request.getParameter("transitName");
	String trainIDs = request.getParameter("trainID");
	String originStations = request.getParameter("originStation");
	String destinationStations = request.getParameter("destinationStation");
	
	String[] transitName = transitNames.split(",");
	String[] trainID = trainIDs.split(",");
	String[] originStation = originStations.split(",");
	String[] destinationStation = destinationStations.split(",");
	
	String value = request.getParameter("discount");
	out.println(value);
	
	ArrayList<Double> fare = new ArrayList<Double>();
	ArrayList<String> departDate = new ArrayList<String>();
	ArrayList<String> departTime = new ArrayList<String>();
	
	int totalRes = 0;
	try{
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();
		String query = "select fare, departure from transit_lines_have where transit_line_name = ? and train_id = ? and origin = ? and destination = ?;";
		PreparedStatement pstmt = con.prepareStatement(query);
		for(int i = 0; i < transitName.length; i++){
			pstmt.setString(1, transitName[i]);
			pstmt.setInt(2, Integer.valueOf(trainID[i]));
			pstmt.setInt(3, Integer.valueOf(originStation[i]));
			pstmt.setInt(4, Integer.valueOf(destinationStation[i]));
			try{
				ResultSet result = pstmt.executeQuery();
				while(result.next()){
					double totalFare = result.getDouble("fixedFare");
					if(value.equals("senior")){
						totalFare = totalFare - (totalFare * .35);
					}else if(value.equals("child")){
						totalFare = totalFare - (totalFare * .25);
					}else if(value.equals("disable")){
						totalFare = totalFare - (totalFare * .5);
					}
					fare.add(totalFare);
					String departDatetime = result.getString("departDatetime");
					String[] dDatetime = departDatetime.split(" ");
					departDate.add(dDatetime[0]);
					departTime.add(dDatetime[1]);
				}
				result.close();
			}catch(Exception e){
				out.println("Query Failed");
				out.println(e);
				out.println("Query failed! Please try again!");
			}
		}
		
		query = "select count(*) as \"totalRes\" from Reservations;";
		pstmt = con.prepareStatement(query);
		try{
			ResultSet result = pstmt.executeQuery();
			while(result.next()){
				totalRes = result.getInt("totalRes");
			}
		}catch(Exception e){
			out.println("Query Failed");
			out.println(e);
			out.println("Query failed! Please try again!");
		}
		
		query = "insert into reservations values (?, ?, ?, ?);";
		pstmt = con.prepareStatement(query);
		for(int i = 0; i < transitName.length; i++){
			pstmt.setInt(1, totalRes);
			pstmt.setString(2, dateOfCreation);
			pstmt.setString(3, username);
			pstmt.setString(4, transitName[i]);
			pstmt.setInt(5, Integer.valueOf(trainID[i]));
			pstmt.setInt(6, Integer.valueOf(originStation[i]));
			pstmt.setInt(7, Integer.valueOf(destinationStation[i]));
			pstmt.setString(8, departTime.get(i));
			pstmt.setString(9, departDate.get(i));
			pstmt.setDouble(10, fare.get(i));
			totalRes++;
			out.println(pstmt);
			try{
				pstmt.executeUpdate();
			}catch(Exception e){
				out.println("Failed to insert " + String.valueOf(totalRes) + transitName[i] + " " + trainID[i] + " " + " " + originStation[i] + " " + destinationStation[i]);
				out.println(e);
				out.println("Failed to insert " + transitName[i] + " " + trainID[i] + " " + " " + originStation[i] + " " + destinationStation[i]);
			}
			
		}
		pstmt.close();
		out.println("Disconnecting from database");
		con.close();
	}catch(Exception e){
		out.println("Failed to connect to database");
		out.println(e);
		out.println("Failed to connect to database");
	}
	%>
	<div>
		<h2>
			Please go back to <a href="customerHome.jsp">home</a>.
		</h2>
	</div>
</body>
</html>

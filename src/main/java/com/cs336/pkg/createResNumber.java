package com.cs336.pkg;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class createResNumber {
	public static int getNextReservationNumber(Connection conn) throws SQLException {
	    String query = "SELECT MAX(res_number) FROM Reservations";
	    PreparedStatement ps = conn.prepareStatement(query);
	    ResultSet rs = ps.executeQuery();

	    int nextResNumber = 1;
	    if (rs.next()) {
	        int maxResNumber = rs.getInt(1);
	        if (!rs.wasNull()) {
	            nextResNumber = maxResNumber + 1;
	        }
	    }

	    System.out.println("Generated reservation number: " + nextResNumber);

	    rs.close();
	    ps.close();

	    return nextResNumber;
	}
	public static int getStationID(Connection conn, String stationName) throws SQLException {
	    String query = "SELECT station_id FROM stations WHERE station_name = ?";
	    PreparedStatement ps = conn.prepareStatement(query);
	    ps.setString(1, stationName);
	    ResultSet rs = ps.executeQuery();

	    int stationId = -1; // Default value if not found
	    if (rs.next()) {
	        stationId = rs.getInt("station_id");
	    }

	    rs.close();
	    ps.close();

	    return stationId;
	}
}

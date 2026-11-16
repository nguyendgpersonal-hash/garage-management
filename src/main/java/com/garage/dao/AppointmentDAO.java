package com.garage.dao;

import com.garage.model.Appointment;
import java.sql.*;

public class AppointmentDAO extends DAO {
    public Appointment createAppointment(Appointment a) throws SQLException {
        String sql="INSERT INTO tblAppointment(customerId,appointmentDate,appointmentTime,status) VALUES(?,?,?,'BOOKED')";
        try(Connection c=getConnection();PreparedStatement ps=c.prepareStatement(sql,Statement.RETURN_GENERATED_KEYS)){
            ps.setInt(1,a.getCustomerId());ps.setDate(2,Date.valueOf(a.getAppointmentDate()));ps.setTime(3,Time.valueOf(a.getAppointmentTime()));ps.executeUpdate();
            try(ResultSet keys=ps.getGeneratedKeys()){if(keys.next())a.setAppointmentId(keys.getInt(1));}a.setStatus("BOOKED");return a;
        }
    }
}

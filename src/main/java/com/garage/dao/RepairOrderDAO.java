package com.garage.dao;

import com.garage.model.RepairOrder;
import java.sql.*;

public class RepairOrderDAO extends DAO {
    public int createRepairOrder(Connection c, RepairOrder r) throws SQLException {
        String sql="INSERT INTO tblRepairOrder(customerId,vehicleId,salesStaffId,technicianId,receivedAt,repairDescription,status) VALUES(?,?,?,?,NOW(),?,'RECEIVED')";
        try(PreparedStatement ps=c.prepareStatement(sql,Statement.RETURN_GENERATED_KEYS)){
            ps.setInt(1,r.getCustomerId());ps.setInt(2,r.getVehicleId());ps.setInt(3,r.getSalesStaffId());ps.setInt(4,r.getTechnicianId());ps.setString(5,r.getRepairDescription());ps.executeUpdate();
            try(ResultSet keys=ps.getGeneratedKeys()){if(keys.next())return keys.getInt(1);}
        }
        throw new SQLException("Không lấy được mã phiếu tiếp nhận.");
    }
}

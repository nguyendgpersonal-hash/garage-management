package com.garage.dao;

import com.garage.model.Vehicle;
import java.sql.*;

public class VehicleDAO extends DAO {
    /** Reuse an existing plate for the same customer; reject plates owned by another customer. */
    public Vehicle createVehicle(Vehicle v) throws SQLException {
        String find = "SELECT vehicleId,customerId FROM tblVehicle WHERE licensePlate=?";
        try (Connection c=getConnection(); PreparedStatement ps=c.prepareStatement(find)) {
            ps.setString(1,v.getLicensePlate().trim());
            try(ResultSet rs=ps.executeQuery()) {
                if(rs.next()) {
                    if(rs.getInt("customerId") != v.getCustomerId()) throw new SQLException("Biển số xe đã được đăng ký cho khách hàng khác.");
                    v.setVehicleId(rs.getInt("vehicleId"));
                    return v;
                }
            }
            String sql="INSERT INTO tblVehicle(customerId,licensePlate,brand,model,manufactureYear,color) VALUES(?,?,?,?,?,?)";
            try(PreparedStatement ins=c.prepareStatement(sql,Statement.RETURN_GENERATED_KEYS)) {
                ins.setInt(1,v.getCustomerId()); ins.setString(2,v.getLicensePlate().trim()); ins.setString(3,v.getBrand().trim());
                ins.setString(4,v.getModel().trim()); ins.setInt(5,v.getManufactureYear()); ins.setString(6,v.getColor().trim());
                ins.executeUpdate(); try(ResultSet keys=ins.getGeneratedKeys()){if(keys.next())v.setVehicleId(keys.getInt(1));}
            }
            return v;
        }
    }
}

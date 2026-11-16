package com.garage.dao;

import java.sql.*;
import java.util.Map;

public class RepairOrderServiceItemDAO extends DAO {
    public void saveServiceItems(Connection c,int repairOrderId,Map<Integer,java.math.BigDecimal> servicePrices)throws SQLException{
        String sql="INSERT INTO tblRepairOrderServiceItem(repairOrderId,serviceId,servicePrice) VALUES(?,?,?)";
        try(PreparedStatement ps=c.prepareStatement(sql)){for(var e:servicePrices.entrySet()){ps.setInt(1,repairOrderId);ps.setInt(2,e.getKey());ps.setBigDecimal(3,e.getValue());ps.addBatch();}ps.executeBatch();}
    }
}

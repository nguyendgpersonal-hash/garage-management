package com.garage.dao;

import java.sql.*;
import java.math.BigDecimal;
import java.util.Map;

public class RepairOrderPartItemDAO extends DAO {
    public void savePartItems(Connection c,int repairOrderId,Map<Integer,Integer> quantities,Map<Integer,BigDecimal> prices)throws SQLException{
        String sql="INSERT INTO tblRepairOrderPartItem(repairOrderId,sparePartId,quantity,unitPrice) VALUES(?,?,?,?)";
        try(PreparedStatement ps=c.prepareStatement(sql)){for(var e:quantities.entrySet()){ps.setInt(1,repairOrderId);ps.setInt(2,e.getKey());ps.setInt(3,e.getValue());ps.setBigDecimal(4,prices.get(e.getKey()));ps.addBatch();}ps.executeBatch();}
    }
}

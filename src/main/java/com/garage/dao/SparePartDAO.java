package com.garage.dao;

import com.garage.model.SparePart;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class SparePartDAO extends DAO {
    public List<SparePart> searchByName(String keyword) throws SQLException {
        String sql="SELECT sparePartId,partName,description,unitPrice,stockQuantity FROM tblSparePart WHERE partName LIKE ? AND isActive=1 ORDER BY partName LIMIT 100";
        try(Connection c=getConnection();PreparedStatement ps=c.prepareStatement(sql)){
            ps.setString(1,"%"+(keyword==null?"":keyword.trim())+"%");
            try(ResultSet rs=ps.executeQuery()){List<SparePart> list=new ArrayList<>();while(rs.next()){SparePart p=new SparePart();p.setSparePartId(rs.getInt("sparePartId"));p.setPartName(rs.getString("partName"));p.setDescription(rs.getString("description"));p.setUnitPrice(rs.getBigDecimal("unitPrice"));p.setStockQuantity(rs.getInt("stockQuantity"));list.add(p);}return list;}
        }
    }
    public SparePart findById(Connection c,int id)throws SQLException{
        String sql="SELECT sparePartId,partName,description,unitPrice,stockQuantity FROM tblSparePart WHERE sparePartId=? AND isActive=1";
        try(PreparedStatement ps=c.prepareStatement(sql)){ps.setInt(1,id);try(ResultSet rs=ps.executeQuery()){if(!rs.next())return null;SparePart p=new SparePart();p.setSparePartId(id);p.setPartName(rs.getString("partName"));p.setDescription(rs.getString("description"));p.setUnitPrice(rs.getBigDecimal("unitPrice"));p.setStockQuantity(rs.getInt("stockQuantity"));return p;}}
    }
    public SparePart findById(int id) throws SQLException { try(Connection c=getConnection()){ return findById(c,id); } }
    public void decreaseStock(Connection c,int id,int quantity)throws SQLException{
        String sql="UPDATE tblSparePart SET stockQuantity=stockQuantity-? WHERE sparePartId=? AND stockQuantity>=?";
        try(PreparedStatement ps=c.prepareStatement(sql)){ps.setInt(1,quantity);ps.setInt(2,id);ps.setInt(3,quantity);if(ps.executeUpdate()!=1)throw new SQLException("Phụ tùng không đủ tồn kho hoặc không còn hoạt động (mã " + id + ").");}
    }
}

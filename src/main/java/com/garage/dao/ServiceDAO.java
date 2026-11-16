package com.garage.dao;

import com.garage.model.Service;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ServiceDAO extends DAO {
    public List<Service> searchByName(String keyword) throws SQLException {
        String sql="SELECT serviceId,serviceName,description,servicePrice FROM tblService WHERE serviceName LIKE ? AND isActive=1 ORDER BY serviceName LIMIT 100";
        try(Connection c=getConnection();PreparedStatement ps=c.prepareStatement(sql)){
            ps.setString(1,"%"+(keyword==null?"":keyword.trim())+"%");
            try(ResultSet rs=ps.executeQuery()){List<Service> list=new ArrayList<>();while(rs.next()){Service s=new Service();s.setServiceId(rs.getInt("serviceId"));s.setServiceName(rs.getString("serviceName"));s.setDescription(rs.getString("description"));s.setServicePrice(rs.getBigDecimal("servicePrice"));list.add(s);}return list;}
        }
    }
    public Service findById(Connection c,int id)throws SQLException{
        String sql="SELECT serviceId,serviceName,description,servicePrice FROM tblService WHERE serviceId=? AND isActive=1";
        try(PreparedStatement ps=c.prepareStatement(sql)){ps.setInt(1,id);try(ResultSet rs=ps.executeQuery()){if(!rs.next())return null;Service s=new Service();s.setServiceId(id);s.setServiceName(rs.getString("serviceName"));s.setDescription(rs.getString("description"));s.setServicePrice(rs.getBigDecimal("servicePrice"));return s;}}
    }
    public Service findById(int id) throws SQLException { try(Connection c=getConnection()){ return findById(c,id); } }
}

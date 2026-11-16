package com.garage.dao;

import com.garage.model.Employee;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class EmployeeDAO extends DAO {
    public List<Employee> getSalesStaff() throws SQLException { return getByPosition("SALES"); }
    public List<Employee> getTechnicianList() throws SQLException { return getByPosition("TECHNICIAN"); }
    public Employee findById(int id) throws SQLException {
        String sql = "SELECT e.employeeId,e.employeeCode,p.fullName,e.jobPosition FROM tblEmployee e JOIN tblPerson p ON p.personId=e.employeeId WHERE e.employeeId=?";
        try (Connection c=getConnection(); PreparedStatement ps=c.prepareStatement(sql)) {
            ps.setInt(1,id); try(ResultSet rs=ps.executeQuery()) { return rs.next()?new Employee(rs.getInt(1),rs.getString(2),rs.getString(3),rs.getString(4)):null; }
        }
    }
    private List<Employee> getByPosition(String position) throws SQLException {
        String sql = "SELECT e.employeeId,e.employeeCode,p.fullName,e.jobPosition FROM tblEmployee e JOIN tblPerson p ON p.personId=e.employeeId WHERE e.jobPosition=? ORDER BY p.fullName";
        try(Connection c=getConnection(); PreparedStatement ps=c.prepareStatement(sql)) {
            ps.setString(1,position); try(ResultSet rs=ps.executeQuery()) { List<Employee> list=new ArrayList<>(); while(rs.next()) list.add(new Employee(rs.getInt(1),rs.getString(2),rs.getString(3),rs.getString(4))); return list; }
        }
    }
}

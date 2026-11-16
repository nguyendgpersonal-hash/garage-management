package com.garage.dao;

import com.garage.model.Customer;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CustomerDAO extends DAO {
    private Customer map(ResultSet rs) throws SQLException {
        Date dob = rs.getDate("dateOfBirth");
        return new Customer(rs.getInt("personId"), rs.getString("fullName"), rs.getString("address"),
                dob == null ? null : dob.toLocalDate(), rs.getString("email"), rs.getString("phone"));
    }

    public List<Customer> findByName(String name) throws SQLException {
        String sql = "SELECT personId,fullName,address,dateOfBirth,email,phone FROM tblPerson WHERE personType='CUSTOMER' AND fullName LIKE ? ORDER BY fullName LIMIT 50";
        try (Connection c = getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, "%" + name.trim() + "%");
            try (ResultSet rs = ps.executeQuery()) { List<Customer> list = new ArrayList<>(); while (rs.next()) list.add(map(rs)); return list; }
        }
    }

    public Customer findByPhone(String phone) throws SQLException {
        String sql = "SELECT personId,fullName,address,dateOfBirth,email,phone FROM tblPerson WHERE personType='CUSTOMER' AND phone=? LIMIT 1";
        try (Connection c = getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, phone.trim());
            try (ResultSet rs = ps.executeQuery()) { return rs.next() ? map(rs) : null; }
        }
    }

    public Customer findById(int id) throws SQLException {
        String sql = "SELECT personId,fullName,address,dateOfBirth,email,phone FROM tblPerson WHERE personType='CUSTOMER' AND personId=?";
        try (Connection c = getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) { return rs.next() ? map(rs) : null; }
        }
    }

    public Customer saveCustomer(Customer customer) throws SQLException {
        String sql = "INSERT INTO tblPerson(fullName,address,dateOfBirth,email,phone,personType) VALUES(?,?,?,?,?,'CUSTOMER')";
        try (Connection c = getConnection(); PreparedStatement ps = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, customer.getFullName().trim());
            ps.setString(2, customer.getAddress().trim());
            if (customer.getDateOfBirth() == null) ps.setNull(3, Types.DATE); else ps.setDate(3, Date.valueOf(customer.getDateOfBirth()));
            ps.setString(4, customer.getEmail().trim());
            ps.setString(5, customer.getPhone().trim());
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) { if (keys.next()) customer.setPersonId(keys.getInt(1)); }
            return customer;
        }
    }
}

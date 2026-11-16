package com.garage.dao;

import com.garage.config.DBConnection;
import java.sql.Connection;
import java.sql.SQLException;

/** Base DAO: keeps database connection creation in one place. */
public abstract class DAO {
    protected Connection getConnection() throws SQLException { return DBConnection.getConnection(); }
}

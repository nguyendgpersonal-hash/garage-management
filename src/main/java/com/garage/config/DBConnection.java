package com.garage.config;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/** Shared JDBC connection factory. Configure with GARAGE_DB_URL/USER/PASSWORD. */
public final class DBConnection {
    private static final String DEFAULT_URL = "jdbc:mysql://localhost:3306/garage_db?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Ho_Chi_Minh&useSSL=false&allowPublicKeyRetrieval=true";
    private DBConnection() {}

    public static Connection getConnection() throws SQLException {
        // Explicitly register Connector/J so a missing driver is reported clearly.
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException ex) {
            throw new SQLException(
                "Không tìm thấy MySQL Connector/J. Hãy kiểm tra mysql-connector-j " +
                "đã được đóng gói trong WEB-INF/lib của file WAR hay chưa, sau đó chạy lại mvn clean package.",
                ex
            );
        }

        String url = System.getenv().getOrDefault("GARAGE_DB_URL", DEFAULT_URL);
        String user = System.getenv().getOrDefault("GARAGE_DB_USER", "root");
        String password = System.getenv().getOrDefault("GARAGE_DB_PASSWORD", "");
        return DriverManager.getConnection(url, user, password);
    }
}

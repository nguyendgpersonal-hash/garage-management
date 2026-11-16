# Sửa lỗi MySQL JDBC driver

Bản này bổ sung nạp rõ `com.mysql.cj.jdbc.Driver`, đánh dấu Connector/J là dependency runtime để Maven đóng gói vào `WEB-INF/lib`, và hiển thị lỗi dễ hiểu hơn tại trang tiếp nhận xe.

Từ thư mục chứa `pom.xml`, chạy:

```powershell
mvn clean package
```

Kiểm tra driver có trong WAR:

```powershell
jar tf .\target\garage-management.war | Select-String "WEB-INF/lib/mysql-connector-j"
```

Kết quả cần xuất hiện `WEB-INF/lib/mysql-connector-j-9.5.0.jar`.

Dừng Tomcat bằng Ctrl+C. Sau đó xóa bản deploy cũ và copy WAR mới (đổi đường dẫn Tomcat theo máy):

```powershell
Remove-Item "$env:CATALINA_HOME\webapps\garage-management" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item "$env:CATALINA_HOME\webapps\garage-management.war" -Force -ErrorAction SilentlyContinue
Copy-Item ".\target\garage-management.war" "$env:CATALINA_HOME\webapps\garage-management.war" -Force
```

Đặt `GARAGE_DB_URL`, `GARAGE_DB_USER`, `GARAGE_DB_PASSWORD` trong chính terminal sẽ chạy Tomcat, rồi khởi động:

```powershell
& "$env:CATALINA_HOME\bin\catalina.bat" run
```

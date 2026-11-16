# PHẦN MỀM QUẢN LÝ GARA Ô TÔ

Phiên bản demo triển khai hai module đã phân tích trong báo cáo:

1. **Customer Books an Appointment Online** – Khách hàng đặt lịch hẹn trực tuyến.
2. **Sales Staff Receives the Car for Repair** – Nhân viên bán hàng tiếp nhận xe sửa chữa.

Công nghệ: Java 17, JSP, JDBC, MySQL 8 và Apache Tomcat 10.1. Kiến trúc mã nguồn chia thành `view` (JSP), `dao` (truy xuất dữ liệu), `model` (thực thể). Mỗi trang JSP làm việc trực tiếp với DAO tương ứng; không có một Controller trung tâm.

## 1. Chức năng đã triển khai

### Module 1 – Đặt lịch hẹn trực tuyến

- Khách hàng chọn ngày và giờ hẹn.
- Nhập họ tên, địa chỉ, ngày sinh, email, số điện thoại.
- Hệ thống tìm khách hàng theo số điện thoại; nếu chưa có thì tạo mới.
- Hiển thị trang xác nhận.
- Lưu lịch hẹn vào `tblAppointment` và hiển thị mã lịch hẹn.

### Module 2 – Tiếp nhận xe sửa chữa

- Nhân viên bán hàng chọn nhân viên đang thực hiện tiếp nhận (dữ liệu demo được tạo sẵn).
- Tìm khách hàng theo tên hoặc thêm khách hàng mới.
- Ghi nhận xe theo biển số, hãng, dòng xe, năm sản xuất và màu sắc.
- Tìm và chọn dịch vụ, phụ tùng; nhập số lượng phụ tùng.
- Chọn nhân viên kỹ thuật.
- Kiểm tra thông tin và xác nhận tiếp nhận.
- Lưu phiếu tiếp nhận, chi tiết dịch vụ và chi tiết phụ tùng trong cùng một transaction.
- Khi lưu phụ tùng, hệ thống kiểm tra và trừ tồn kho. Nếu tồn kho không đủ hoặc một bước lưu thất bại, giao dịch được rollback.

## 2. Yêu cầu cài đặt

- JDK 17 trở lên.
- Apache Maven 3.9 trở lên.
- MySQL 8.0.16 trở lên (để áp dụng các CHECK constraint trong script).
- Apache Tomcat 10.1.x.

**Lưu ý:** Dự án dùng Jakarta Servlet/JSP phù hợp Tomcat 10.1. Không dùng Tomcat 9 vì Tomcat 9 sử dụng namespace `javax.*`.

## 3. Tạo cơ sở dữ liệu

1. Mở MySQL Workbench.
2. Mở file `database/garage_db.sql`.
3. Chạy toàn bộ script.
4. Script tạo database `garage_db`, 13 bảng và dữ liệu mẫu cho nhân viên bán hàng, kỹ thuật viên, dịch vụ, phụ tùng, nhà cung cấp.

Script có lệnh DROP các bảng cùng tên để tạo lại dữ liệu demo từ đầu. **Không chạy trên database đang chứa dữ liệu thật.**

## 4. Cấu hình kết nối MySQL

Ứng dụng đọc cấu hình từ biến môi trường:

- `GARAGE_DB_URL`
- `GARAGE_DB_USER`
- `GARAGE_DB_PASSWORD`

Mặc định:

```text
URL: jdbc:mysql://localhost:3306/garage_db?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Ho_Chi_Minh&useSSL=false&allowPublicKeyRetrieval=true
USER: root
PASSWORD: (rỗng)
```

Nếu MySQL của bạn có mật khẩu, đặt biến môi trường trước khi khởi động Tomcat.

Ví dụ PowerShell trên Windows:

```powershell
$env:GARAGE_DB_URL="jdbc:mysql://localhost:3306/garage_db?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Ho_Chi_Minh&useSSL=false&allowPublicKeyRetrieval=true"
$env:GARAGE_DB_USER="root"
$env:GARAGE_DB_PASSWORD="mat_khau_mysql_cua_ban"
```

Thay `mat_khau_mysql_cua_ban` bằng mật khẩu MySQL của bạn. Khởi động Tomcat từ môi trường đã đặt biến này để Tomcat nhận được cấu hình.

## 5. Biên dịch và chạy trên Tomcat

Mở PowerShell/CMD tại thư mục chứa `pom.xml`:

```powershell
mvn clean package
```

Sau khi Maven chạy thành công, file WAR được tạo tại:

```text
target/garage-management.war
```

Sao chép file WAR vào thư mục `webapps` của Tomcat 10.1, sau đó khởi động Tomcat.

Truy cập:

```text
http://localhost:8080/garage-management/
```

## 6. Dữ liệu demo

Script SQL tạo sẵn:

| Vai trò | Mã | Tên |
|---|---|---|
| Nhân viên bán hàng | NVBH001 | Nguyễn Văn Bán Hàng |
| Kỹ thuật viên | NVKT001 | Trần Văn Kỹ Thuật |
| Kỹ thuật viên | NVKT002 | Lê Văn Kỹ Thuật |
| Nhân viên quản lý | NVQL001 | Phạm Thị Quản Lý |
| Nhân viên kho | NVK001 | Hoàng Văn Kho |

Khách hàng mẫu: Nguyễn Văn A, số điện thoại `0987654321`.

Dịch vụ và phụ tùng mẫu cũng đã được thêm để kiểm thử hai module.

## 7. Cấu trúc thư mục

```text
garage-management/
├── database/
│   └── garage_db.sql
├── src/main/java/com/garage/
│   ├── config/       # JDBC connection
│   ├── dao/          # DAO classes
│   ├── model/        # Entity/model classes
│   └── util/         # HTML escaping helper
├── src/main/webapp/
│   ├── assets/       # CSS
│   ├── customer/     # Module đặt lịch hẹn
│   ├── sales/        # Module tiếp nhận xe
│   └── WEB-INF/
├── pom.xml
└── README.md
```

## 8. Phạm vi và giả định của bản demo

- Chưa triển khai đăng nhập, phân quyền và quản lý tài khoản. Trang nhân viên bán hàng cho phép chọn một nhân viên bán hàng từ dữ liệu mẫu để mô phỏng Actor.
- Chưa triển khai các module quản lý dịch vụ, quản lý kho, nhập hàng, thống kê và thanh toán; các bảng CSDL liên quan vẫn được tạo theo thiết kế toàn hệ thống.
- Chưa có cơ chế khóa khung giờ hoặc kiểm tra lịch hẹn trùng. Giờ nhận lịch demo là 08:00–17:30.
- Một xe được gắn với một khách hàng trong mô hình demo. Biển số đã tồn tại thuộc khách hàng khác sẽ bị từ chối.
- Khi xác nhận phiếu sửa chữa, số lượng phụ tùng được trừ khỏi tồn kho trong cùng transaction với phiếu và chi tiết.
- Các bảng DAO dùng trong hai module được triển khai trực tiếp. Một số DAO thuộc các module ngoài phạm vi mới chỉ có trong thiết kế báo cáo/CSDL, chưa có chức năng giao diện.

## 9. Xử lý lỗi thường gặp

**Không kết nối được MySQL:** Kiểm tra MySQL service đang chạy, database `garage_db` đã được tạo và biến môi trường đúng.

**HTTP 500:** Xem log của Tomcat trong `logs/catalina*.log`; lỗi SQL thường do cấu hình kết nối hoặc chưa chạy script tạo CSDL.

**Không thấy nhân viên kỹ thuật:** Chạy lại phần INSERT dữ liệu mẫu trong `database/garage_db.sql` hoặc kiểm tra `tblEmployee.jobPosition='TECHNICIAN'`.

**Phụ tùng không đủ tồn kho:** Chọn số lượng không vượt quá cột `stockQuantity` trong `tblSparePart`.

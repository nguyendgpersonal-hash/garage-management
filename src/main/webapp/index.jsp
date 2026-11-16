<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<jsp:include page="/WEB-INF/header.jsp"><jsp:param name="title" value="Trang chủ - Garage Management"/></jsp:include>
<div class="container">
    <h1 class="page-title">Hệ thống quản lý gara ô tô</h1>
    <p class="sub">Chọn nghiệp vụ cần thực hiện.</p>
    <div class="grid">
        <a class="tile" href="${pageContext.request.contextPath}/customer/gdSelectAppointmentTime.jsp">
            <span class="pill">Module 01 · Customer</span>
            <h3>Đặt lịch hẹn trực tuyến</h3>
            <p>Khách hàng chọn ngày giờ, nhập thông tin cá nhân và xác nhận lịch hẹn tại gara.</p>
        </a>
        <a class="tile" href="${pageContext.request.contextPath}/sales/gdSalesHome.jsp">
            <span class="pill">Module 02 · Sales Staff</span>
            <h3>Tiếp nhận xe sửa chữa</h3>
            <p>Nhân viên tìm khách hàng, ghi nhận xe, chọn dịch vụ/phụ tùng và phân công kỹ thuật viên.</p>
        </a>
    </div>
    <div class="card">
        <h3>Phạm vi phiên bản</h3>
        <p>Phiên bản này triển khai hai module được phân tích trong báo cáo. Các chức năng quản lý kho, quản lý dịch vụ, thống kê và thanh toán chưa được triển khai thành màn hình nghiệp vụ.</p>
    </div>
</div>
<jsp:include page="/WEB-INF/footer.jsp"/>

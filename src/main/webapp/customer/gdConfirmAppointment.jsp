<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.garage.model.Customer,com.garage.util.Html" %>
<jsp:include page="/WEB-INF/header.jsp"><jsp:param name="title" value="Xác nhận lịch hẹn"/></jsp:include>
<%
Customer customer=(Customer)session.getAttribute("bookingCustomer");
String date=(String)session.getAttribute("appointmentDate"), time=(String)session.getAttribute("appointmentTime");
if(customer==null||date==null||time==null){response.sendRedirect(request.getContextPath()+"/customer/gdSelectAppointmentTime.jsp");return;}
%>
<div class="container">
    <div class="step"><span>1. Ngày giờ</span><span>2. Thông tin khách hàng</span><span class="active">3. Xác nhận</span></div>
    <h1 class="page-title">Xác nhận lịch hẹn</h1>
    <p class="sub">Kiểm tra lại thông tin trước khi gửi đăng ký.</p>
    <div class="card"><div class="table-wrap"><table>
        <tr><th colspan="2">Thông tin khách hàng</th></tr>
        <tr><td>Họ và tên</td><td><%=Html.escape(customer.getFullName())%></td></tr>
        <tr><td>Số điện thoại</td><td><%=Html.escape(customer.getPhone())%></td></tr>
        <tr><td>Email</td><td><%=Html.escape(customer.getEmail())%></td></tr>
        <tr><td>Địa chỉ</td><td><%=Html.escape(customer.getAddress())%></td></tr>
        <tr><th colspan="2">Thông tin lịch hẹn</th></tr>
        <tr><td>Ngày hẹn</td><td><%=Html.escape(date)%></td></tr>
        <tr><td>Giờ hẹn</td><td><%=Html.escape(time)%></td></tr>
    </table></div>
    <form method="post" action="<%=request.getContextPath()%>/customer/doSaveAppointment.jsp" class="actions">
        <button type="submit" class="success">Xác nhận đặt lịch</button>
        <a class="btn secondary" href="<%=request.getContextPath()%>/customer/gdEnterCustomerInfo.jsp">Quay lại chỉnh sửa</a>
    </form></div>
</div>
<jsp:include page="/WEB-INF/footer.jsp"/>

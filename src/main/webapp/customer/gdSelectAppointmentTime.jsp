<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.time.LocalDate,java.time.LocalTime,com.garage.util.Html" %>
<jsp:include page="/WEB-INF/header.jsp"><jsp:param name="title" value="Chọn ngày giờ hẹn"/></jsp:include>
<%
String error = null;
if ("POST".equalsIgnoreCase(request.getMethod())) {
    try {
        LocalDate d = LocalDate.parse(request.getParameter("appointmentDate"));
        LocalTime t = LocalTime.parse(request.getParameter("appointmentTime"));
        if (d.isBefore(LocalDate.now())) throw new IllegalArgumentException("Ngày hẹn không được ở trong quá khứ.");
        if (t.isBefore(LocalTime.of(8,0)) || t.isAfter(LocalTime.of(17,30))) throw new IllegalArgumentException("Gara nhận lịch trong khoảng 08:00–17:30.");
        session.setAttribute("appointmentDate", d.toString());
        session.setAttribute("appointmentTime", t.toString());
        response.sendRedirect(request.getContextPath()+"/customer/gdEnterCustomerInfo.jsp");
        return;
    } catch (Exception ex) { error = ex.getMessage() == null ? "Thông tin ngày giờ không hợp lệ." : ex.getMessage(); }
}
%>
<div class="container">
    <div class="step"><span class="active">1. Ngày giờ</span><span>2. Thông tin khách hàng</span><span>3. Xác nhận</span></div>
    <h1 class="page-title">Đặt lịch hẹn trực tuyến</h1>
    <p class="sub">Chọn ngày và giờ bạn dự định đưa xe đến gara.</p>
    <% if(error!=null){ %><div class="alert error"><%=Html.escape(error)%></div><% } %>
    <div class="card">
        <form method="post">
            <div class="form-grid">
                <div><label>Ngày hẹn</label><input type="date" name="appointmentDate" min="<%=LocalDate.now()%>" required value="<%=Html.escape(request.getParameter("appointmentDate"))%>"></div>
                <div><label>Giờ hẹn</label><select name="appointmentTime" required>
                    <option value="">-- Chọn giờ --</option>
                    <% for(int h=8;h<=17;h++){ for(int m : new int[]{0,30}){ if(h==17 && m==30 || h<17 || m==0){String v=String.format("%02d:%02d",h,m); %><option value="<%=v%>"><%=v%></option><%}}}%>
                </select></div>
            </div>
            <div class="actions"><button type="submit">Tiếp tục</button><a class="btn secondary" href="<%=request.getContextPath()%>/index.jsp">Quay lại</a></div>
        </form>
    </div>
</div>
<jsp:include page="/WEB-INF/footer.jsp"/>

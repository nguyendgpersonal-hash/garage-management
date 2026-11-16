<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.garage.util.Html" %>
<jsp:include page="/WEB-INF/header.jsp"><jsp:param name="title" value="Kết quả đặt lịch"/></jsp:include>
<%
boolean ok="1".equals(request.getParameter("success"));Object appointmentId=session.getAttribute("savedAppointmentId");String err=(String)session.getAttribute("bookingError");session.removeAttribute("bookingError");
%>
<div class="container"><div class="card">
<%if(ok){%><div class="alert success"><h2>Đặt lịch thành công</h2>Thông tin lịch hẹn đã được lưu vào hệ thống.</div>
<table><tr><th>Mã lịch hẹn</th><td>AP<%=appointmentId==null?"":Html.escape(appointmentId)%></td></tr></table>
<%}else{%><div class="alert error"><h2>Không thể đặt lịch</h2><%=Html.escape(err==null?"Vui lòng thực hiện lại thao tác.":err)%></div><%}%>
<div class="actions"><a class="btn" href="<%=request.getContextPath()%>/customer/gdSelectAppointmentTime.jsp">Đặt lịch mới</a><a class="btn secondary" href="<%=request.getContextPath()%>/index.jsp">Trang chủ</a></div>
</div></div>
<jsp:include page="/WEB-INF/footer.jsp"/>

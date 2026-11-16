<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.garage.util.Html" %>
<jsp:include page="/WEB-INF/header.jsp"><jsp:param name="title" value="Kết quả tiếp nhận xe"/></jsp:include>
<%
boolean ok="1".equals(request.getParameter("success"));Object id=session.getAttribute("savedRepairOrderId");String err=(String)session.getAttribute("receptionError");session.removeAttribute("receptionError");
%>
<div class="container"><div class="card">
<%if(ok){%><div class="alert success"><h2>Tiếp nhận xe thành công</h2>Phiếu tiếp nhận và các chi tiết dịch vụ/phụ tùng đã được lưu.</div>
<table><tr><th>Mã phiếu tiếp nhận</th><td>RO<%=id==null?"":Html.escape(id)%></td></tr></table>
<%}else{%><div class="alert error"><h2>Tiếp nhận xe chưa thành công</h2><%=Html.escape(err==null?"Vui lòng kiểm tra dữ liệu và thực hiện lại.":err)%></div><%}%>
<div class="actions"><%if(!ok){%><a class="btn" href="<%=request.getContextPath()%>/sales/gdConfirmRepairReception.jsp">Quay lại xác nhận</a><%}%><a class="btn secondary" href="<%=request.getContextPath()%>/sales/gdSalesHome.jsp">Tiếp nhận xe khác</a><a class="btn secondary" href="<%=request.getContextPath()%>/index.jsp">Trang chủ</a></div>
</div></div>
<jsp:include page="/WEB-INF/footer.jsp"/>

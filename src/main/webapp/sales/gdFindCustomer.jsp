<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.garage.dao.CustomerDAO,com.garage.model.Customer,com.garage.util.Html,java.util.List" %>
<jsp:include page="/WEB-INF/header.jsp"><jsp:param name="title" value="Tìm kiếm khách hàng"/></jsp:include>
<%
if(session.getAttribute("salesStaffId")==null){response.sendRedirect(request.getContextPath()+"/sales/gdSalesHome.jsp");return;}
String q=request.getParameter("q");List<Customer> customers=(q==null||q.isBlank())?java.util.Collections.emptyList():new CustomerDAO().findByName(q);
%>
<div class="container">
<h1 class="page-title">Tìm kiếm khách hàng</h1><p class="sub">Nhân viên: <b><%=Html.escape(session.getAttribute("salesStaffName"))%></b></p>
<div class="card"><form method="get">
<label>Tên khách hàng</label><input name="q" placeholder="Nhập tên khách hàng cần tìm" value="<%=Html.escape(q)%>">
<div class="actions"><button type="submit">Tìm kiếm</button><a class="btn secondary" href="<%=request.getContextPath()%>/sales/gdAddCustomer.jsp">Thêm khách hàng mới</a></div>
</form></div>
<%if(q!=null&&!q.isBlank()){%>
<div class="card"><h3>Kết quả tìm kiếm</h3><%if(customers.isEmpty()){%><div class="alert info">Không tìm thấy khách hàng phù hợp. Có thể thêm khách hàng mới.</div><%}else{%>
<div class="table-wrap"><table><thead><tr><th>TT</th><th>Mã</th><th>Họ tên</th><th>Số điện thoại</th><th>Email</th><th>Chọn</th></tr></thead><tbody>
<%int i=1;for(Customer c:customers){%><tr><td><%=i++%></td><td>KH<%=c.getPersonId()%></td><td><%=Html.escape(c.getFullName())%></td><td><%=Html.escape(c.getPhone())%></td><td><%=Html.escape(c.getEmail())%></td><td><form method="post" action="gdRecordVehicle.jsp"><input type="hidden" name="customerId" value="<%=c.getPersonId()%>"><button type="submit">Chọn</button></form></td></tr><%}%>
</tbody></table></div><%}%></div><%}%>
<div class="actions"><a class="btn secondary" href="<%=request.getContextPath()%>/sales/gdSalesHome.jsp">Quay lại</a></div>
</div>
<jsp:include page="/WEB-INF/footer.jsp"/>

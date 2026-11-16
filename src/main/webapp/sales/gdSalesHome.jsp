<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.garage.dao.EmployeeDAO,com.garage.model.Employee,com.garage.util.Html,java.util.List,java.util.ArrayList" %>
<jsp:include page="/WEB-INF/header.jsp"><jsp:param name="title" value="Khu vực nhân viên bán hàng"/></jsp:include>
<%
String error=null;
List<Employee> salesStaffList=new ArrayList<>();
try {
    salesStaffList=new EmployeeDAO().getSalesStaff();
} catch(Exception ex) {
    application.log("Không thể tải danh sách nhân viên bán hàng.", ex);
    error="Không thể tải danh sách nhân viên. Hãy kiểm tra MySQL Server và MySQL Connector/J, sau đó xem log Tomcat để biết chi tiết.";
}
if("POST".equalsIgnoreCase(request.getMethod())){
 try{int id=Integer.parseInt(request.getParameter("salesStaffId"));Employee selected=null;for(Employee e:salesStaffList)if(e.getEmployeeId()==id)selected=e;if(selected==null)throw new IllegalArgumentException("Nhân viên bán hàng không hợp lệ.");session.removeAttribute("selectedCustomer");session.removeAttribute("selectedVehicle");session.removeAttribute("selectedServiceIds");session.removeAttribute("selectedPartQuantities");session.removeAttribute("selectedTechnicianId");session.removeAttribute("selectedTechnicianName");session.removeAttribute("repairDescription");session.removeAttribute("receptionError");session.removeAttribute("savedRepairOrderId");session.setAttribute("salesStaffId",id);session.setAttribute("salesStaffName",selected.getFullName());response.sendRedirect(request.getContextPath()+"/sales/gdFindCustomer.jsp");return;}
 catch(Exception ex){error=ex.getMessage();}
}
%>
<div class="container">
<h1 class="page-title">Tiếp nhận xe sửa chữa</h1>
<p class="sub">Chọn nhân viên bán hàng đang thực hiện tiếp nhận xe.</p>
<%if(error!=null){%><div class="alert error"><%=Html.escape(error)%></div><%}%>
<div class="card"><form method="post">
<label>Nhân viên bán hàng</label>
<select name="salesStaffId" required><option value="">-- Chọn nhân viên --</option><%for(Employee e:salesStaffList){%><option value="<%=e.getEmployeeId()%>"><%=Html.escape(e.getEmployeeCode()+" - "+e.getFullName())%></option><%}%></select>
<div class="actions"><button type="submit">Bắt đầu tiếp nhận xe</button><a class="btn secondary" href="<%=request.getContextPath()%>/index.jsp">Quay lại</a></div>
</form></div>
</div>
<jsp:include page="/WEB-INF/footer.jsp"/>

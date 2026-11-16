<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.garage.dao.CustomerDAO,com.garage.dao.VehicleDAO,com.garage.model.Customer,com.garage.model.Vehicle,com.garage.util.Html" %>
<jsp:include page="/WEB-INF/header.jsp"><jsp:param name="title" value="Ghi nhận thông tin xe"/></jsp:include>
<%
if(session.getAttribute("salesStaffId")==null){response.sendRedirect(request.getContextPath()+"/sales/gdSalesHome.jsp");return;}
String error=null;Customer customer=(Customer)session.getAttribute("selectedCustomer");
if("POST".equalsIgnoreCase(request.getMethod())&&request.getParameter("customerId")!=null){try{customer=new CustomerDAO().findById(Integer.parseInt(request.getParameter("customerId")));if(customer==null)throw new IllegalArgumentException("Không tìm thấy khách hàng.");session.setAttribute("selectedCustomer",customer);}catch(Exception ex){error=ex.getMessage();}}
if("POST".equalsIgnoreCase(request.getMethod())&&request.getParameter("licensePlate")!=null){try{
 if(customer==null)throw new IllegalStateException("Chưa chọn khách hàng.");
 Vehicle v=new Vehicle();v.setCustomerId(customer.getPersonId());v.setLicensePlate(request.getParameter("licensePlate"));v.setBrand(request.getParameter("brand"));v.setModel(request.getParameter("model"));v.setManufactureYear(Integer.parseInt(request.getParameter("manufactureYear")));v.setColor(request.getParameter("color"));
 v=new VehicleDAO().createVehicle(v);session.setAttribute("selectedVehicle",v);response.sendRedirect(request.getContextPath()+"/sales/gdSelectServicePart.jsp");return;
 }catch(Exception ex){error=ex.getMessage()==null?"Không thể lưu thông tin xe.":ex.getMessage();}}
if(customer==null){response.sendRedirect(request.getContextPath()+"/sales/gdFindCustomer.jsp");return;}
%>
<div class="container"><div class="step"><span>1. Khách hàng</span><span class="active">2. Xe</span><span>3. Dịch vụ & phụ tùng</span><span>4. Kỹ thuật viên</span><span>5. Xác nhận</span></div>
<h1 class="page-title">Ghi nhận thông tin xe</h1>
<%if(error!=null){%><div class="alert error"><%=Html.escape(error)%></div><%}%>
<div class="card"><h3>Khách hàng đã chọn</h3><p><b><%=Html.escape(customer.getFullName())%></b> · <%=Html.escape(customer.getPhone())%></p></div>
<div class="card"><form method="post"><div class="form-grid">
<div><label>Biển số xe *</label><input name="licensePlate" required placeholder="30A-12345" value="<%=Html.escape(request.getParameter("licensePlate"))%>"></div>
<div><label>Hãng xe *</label><input name="brand" required value="<%=Html.escape(request.getParameter("brand"))%>"></div>
<div><label>Dòng xe *</label><input name="model" required value="<%=Html.escape(request.getParameter("model"))%>"></div>
<div><label>Năm sản xuất *</label><input type="number" name="manufactureYear" min="1950" max="2100" required value="<%=Html.escape(request.getParameter("manufactureYear"))%>"></div>
<div><label>Màu sắc *</label><input name="color" required value="<%=Html.escape(request.getParameter("color"))%>"></div>
</div><div class="actions"><button type="submit">Lưu xe và tiếp tục</button><a class="btn secondary" href="gdFindCustomer.jsp">Chọn lại khách hàng</a></div></form></div>
</div>
<jsp:include page="/WEB-INF/footer.jsp"/>

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.garage.dao.CustomerDAO,com.garage.model.Customer,com.garage.util.Html,java.time.LocalDate" %>
<jsp:include page="/WEB-INF/header.jsp"><jsp:param name="title" value="Thêm khách hàng"/></jsp:include>
<%
if(session.getAttribute("salesStaffId")==null){response.sendRedirect(request.getContextPath()+"/sales/gdSalesHome.jsp");return;}
String error=null;
if("POST".equalsIgnoreCase(request.getMethod())){try{
 String name=request.getParameter("fullName"),address=request.getParameter("address"),email=request.getParameter("email"),phone=request.getParameter("phone"),dob=request.getParameter("dateOfBirth");
 if(name==null||name.isBlank()||address==null||address.isBlank()||email==null||email.isBlank()||phone==null||phone.isBlank())throw new IllegalArgumentException("Vui lòng nhập đầy đủ các trường bắt buộc.");
 CustomerDAO dao=new CustomerDAO();Customer existing=dao.findByPhone(phone.trim());
 Customer c;
 if(existing!=null)c=existing;else{c=new Customer();c.setFullName(name.trim());c.setAddress(address.trim());c.setEmail(email.trim());c.setPhone(phone.trim());c.setDateOfBirth(dob==null||dob.isBlank()?null:LocalDate.parse(dob));c=dao.saveCustomer(c);}
 session.setAttribute("selectedCustomer",c);response.sendRedirect(request.getContextPath()+"/sales/gdRecordVehicle.jsp");return;
}catch(Exception ex){error=ex.getMessage()==null?"Không thể lưu khách hàng.":ex.getMessage();}}
%>
<div class="container"><h1 class="page-title">Thêm khách hàng mới</h1><p class="sub">Nhập thông tin khách hàng để tiếp tục tiếp nhận xe.</p>
<%if(error!=null){%><div class="alert error"><%=Html.escape(error)%></div><%}%>
<div class="card"><form method="post"><div class="form-grid">
<div><label>Họ và tên *</label><input name="fullName" required value="<%=Html.escape(request.getParameter("fullName"))%>"></div>
<div><label>Số điện thoại *</label><input name="phone" required value="<%=Html.escape(request.getParameter("phone"))%>"></div>
<div><label>Email *</label><input type="email" name="email" required value="<%=Html.escape(request.getParameter("email"))%>"></div>
<div><label>Ngày sinh</label><input type="date" name="dateOfBirth" value="<%=Html.escape(request.getParameter("dateOfBirth"))%>"></div>
<div style="grid-column:1/-1"><label>Địa chỉ *</label><input name="address" required value="<%=Html.escape(request.getParameter("address"))%>"></div>
</div><div class="actions"><button type="submit">Lưu khách hàng và tiếp tục</button><a class="btn secondary" href="gdFindCustomer.jsp">Quay lại</a></div></form></div>
</div>
<jsp:include page="/WEB-INF/footer.jsp"/>

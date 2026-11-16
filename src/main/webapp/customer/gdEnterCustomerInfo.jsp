<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.garage.dao.CustomerDAO,com.garage.model.Customer,com.garage.util.Html,java.time.LocalDate" %>
<jsp:include page="/WEB-INF/header.jsp"><jsp:param name="title" value="Thông tin khách hàng"/></jsp:include>
<%
String error=null;
if(session.getAttribute("appointmentDate")==null || session.getAttribute("appointmentTime")==null){response.sendRedirect(request.getContextPath()+"/customer/gdSelectAppointmentTime.jsp");return;}
if("POST".equalsIgnoreCase(request.getMethod())){
 try{
  String fullName=request.getParameter("fullName"), address=request.getParameter("address"), email=request.getParameter("email"), phone=request.getParameter("phone"), dob=request.getParameter("dateOfBirth");
  if(fullName==null||fullName.isBlank()||address==null||address.isBlank()||email==null||email.isBlank()||phone==null||phone.isBlank()) throw new IllegalArgumentException("Vui lòng nhập đầy đủ họ tên, địa chỉ, email và số điện thoại.");
  if(!email.matches("^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$")) throw new IllegalArgumentException("Email không đúng định dạng.");
  CustomerDAO dao=new CustomerDAO();
  Customer customer=dao.findByPhone(phone.trim());
  if(customer==null){customer=new Customer();customer.setFullName(fullName.trim());customer.setAddress(address.trim());customer.setEmail(email.trim());customer.setPhone(phone.trim());customer.setDateOfBirth(dob==null||dob.isBlank()?null:LocalDate.parse(dob));customer=dao.saveCustomer(customer);}
  session.setAttribute("bookingCustomer",customer);
  response.sendRedirect(request.getContextPath()+"/customer/gdConfirmAppointment.jsp");return;
 }catch(Exception ex){error=ex.getMessage()==null?"Không thể lưu thông tin khách hàng.":ex.getMessage();}
}
%>
<div class="container">
    <div class="step"><span>1. Ngày giờ</span><span class="active">2. Thông tin khách hàng</span><span>3. Xác nhận</span></div>
    <h1 class="page-title">Thông tin khách hàng</h1>
    <p class="sub">Thông tin được dùng để liên hệ và xác nhận lịch hẹn.</p>
    <%if(error!=null){%><div class="alert error"><%=Html.escape(error)%></div><%}%>
    <div class="card"><form method="post">
        <div class="form-grid">
            <div><label>Họ và tên *</label><input name="fullName" required value="<%=Html.escape(request.getParameter("fullName"))%>"></div>
            <div><label>Số điện thoại *</label><input name="phone" required value="<%=Html.escape(request.getParameter("phone"))%>"></div>
            <div><label>Email *</label><input type="email" name="email" required value="<%=Html.escape(request.getParameter("email"))%>"></div>
            <div><label>Ngày sinh</label><input type="date" name="dateOfBirth" value="<%=Html.escape(request.getParameter("dateOfBirth"))%>"></div>
            <div style="grid-column:1/-1"><label>Địa chỉ *</label><input name="address" required value="<%=Html.escape(request.getParameter("address"))%>"></div>
        </div>
        <div class="actions"><button type="submit">Tiếp tục xác nhận</button><a class="btn secondary" href="<%=request.getContextPath()%>/customer/gdSelectAppointmentTime.jsp">Quay lại</a></div>
    </form></div>
</div>
<jsp:include page="/WEB-INF/footer.jsp"/>

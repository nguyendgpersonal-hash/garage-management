<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.garage.dao.EmployeeDAO,com.garage.model.Employee,com.garage.util.Html,java.util.List" %>
<jsp:include page="/WEB-INF/header.jsp"><jsp:param name="title" value="Chọn nhân viên kỹ thuật"/></jsp:include>
<%
if(session.getAttribute("selectedServiceIds")==null){response.sendRedirect(request.getContextPath()+"/sales/gdSelectServicePart.jsp");return;}
List<Employee> technicians=new EmployeeDAO().getTechnicianList();String error=null;
if("POST".equalsIgnoreCase(request.getMethod())){try{int id=Integer.parseInt(request.getParameter("technicianId"));boolean valid=false;for(Employee e:technicians)if(e.getEmployeeId()==id)valid=true;if(!valid)throw new IllegalArgumentException("Nhân viên kỹ thuật không hợp lệ.");session.setAttribute("selectedTechnicianId",id);for(Employee e:technicians)if(e.getEmployeeId()==id)session.setAttribute("selectedTechnicianName",e.getFullName());response.sendRedirect(request.getContextPath()+"/sales/gdConfirmRepairReception.jsp");return;}catch(Exception ex){error=ex.getMessage();}}
%>
<div class="container"><div class="step"><span>1. Khách hàng</span><span>2. Xe</span><span>3. Dịch vụ & phụ tùng</span><span class="active">4. Kỹ thuật viên</span><span>5. Xác nhận</span></div>
<h1 class="page-title">Phân công nhân viên kỹ thuật</h1><p class="sub">Chọn nhân viên kỹ thuật phụ trách yêu cầu sửa chữa.</p>
<%if(error!=null){%><div class="alert error"><%=Html.escape(error)%></div><%}%>
<div class="card"><form method="post"><div class="table-wrap"><table><thead><tr><th>Chọn</th><th>Mã nhân viên</th><th>Họ tên</th><th>Vị trí</th></tr></thead><tbody>
<%for(Employee e:technicians){%><tr><td><input type="radio" name="technicianId" value="<%=e.getEmployeeId()%>" required></td><td><%=Html.escape(e.getEmployeeCode())%></td><td><%=Html.escape(e.getFullName())%></td><td><%=Html.escape(e.getJobPosition())%></td></tr><%}%>
</tbody></table></div><div class="actions"><button type="submit">Tiếp tục xác nhận</button><a class="btn secondary" href="gdSelectServicePart.jsp">Quay lại</a></div></form></div>
</div>
<jsp:include page="/WEB-INF/footer.jsp"/>

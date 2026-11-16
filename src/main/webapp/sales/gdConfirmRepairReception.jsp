<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.garage.dao.CustomerDAO,com.garage.dao.VehicleDAO,com.garage.dao.ServiceDAO,com.garage.dao.SparePartDAO,com.garage.dao.EmployeeDAO,com.garage.model.*,com.garage.util.Html,java.util.*" %>
<jsp:include page="/WEB-INF/header.jsp"><jsp:param name="title" value="Xác nhận tiếp nhận xe"/></jsp:include>
<%
Customer customer=(Customer)session.getAttribute("selectedCustomer");Vehicle vehicle=(Vehicle)session.getAttribute("selectedVehicle");
Object sObj=session.getAttribute("selectedServiceIds"),pObj=session.getAttribute("selectedPartQuantities");
Integer techId=(Integer)session.getAttribute("selectedTechnicianId");Integer salesId=(Integer)session.getAttribute("salesStaffId");
if(customer==null||vehicle==null||sObj==null||pObj==null||techId==null||salesId==null){response.sendRedirect(request.getContextPath()+"/sales/gdSalesHome.jsp");return;}
List<Integer> serviceIds=(List<Integer>)sObj;Map<Integer,Integer> quantities=(Map<Integer,Integer>)pObj;
ServiceDAO serviceDAO=new ServiceDAO();SparePartDAO partDAO=new SparePartDAO();EmployeeDAO employeeDAO=new EmployeeDAO();
List<Service> serviceList=new ArrayList<>();for(Integer id:serviceIds){Service s=serviceDAO.findById(id);if(s!=null)serviceList.add(s);}
List<SparePart> partList=new ArrayList<>();for(Integer id:quantities.keySet()){SparePart p=partDAO.findById(id);if(p!=null)partList.add(p);}
Employee tech=employeeDAO.findById(techId);String error=(String)session.getAttribute("receptionError");session.removeAttribute("receptionError");
String repairDescription=(String)session.getAttribute("repairDescription");
%>
<div class="container"><div class="step"><span>1. Khách hàng</span><span>2. Xe</span><span>3. Dịch vụ & phụ tùng</span><span>4. Kỹ thuật viên</span><span class="active">5. Xác nhận</span></div>
<h1 class="page-title">Xác nhận tiếp nhận sửa chữa</h1><p class="sub">Kiểm tra thông tin trước khi tạo phiếu tiếp nhận.</p>
<%if(error!=null){%><div class="alert error"><%=Html.escape(error)%></div><%}%>
<div class="card"><h3>Khách hàng và xe</h3><div class="table-wrap"><table>
<tr><th>Khách hàng</th><td><%=Html.escape(customer.getFullName())%></td><th>Số điện thoại</th><td><%=Html.escape(customer.getPhone())%></td></tr>
<tr><th>Biển số</th><td><%=Html.escape(vehicle.getLicensePlate())%></td><th>Xe</th><td><%=Html.escape(vehicle.getBrand()+" "+vehicle.getModel())%></td></tr>
<tr><th>Năm sản xuất</th><td><%=vehicle.getManufactureYear()%></td><th>Màu sắc</th><td><%=Html.escape(vehicle.getColor())%></td></tr>
</table></div></div>
<div class="card"><h3>Dịch vụ đã chọn</h3><div class="table-wrap"><table><tr><th>Tên dịch vụ</th><th>Giá</th></tr><%for(Service s:serviceList){%><tr><td><%=Html.escape(s.getServiceName())%></td><td class="price"><%=s.getServicePrice().toPlainString()%> đ</td></tr><%}%></table></div></div>
<div class="card"><h3>Phụ tùng đã chọn</h3><div class="table-wrap"><table><tr><th>Tên phụ tùng</th><th>Đơn giá</th><th>Số lượng</th><th>Tồn kho</th></tr><%for(SparePart p:partList){%><tr><td><%=Html.escape(p.getPartName())%></td><td class="price"><%=p.getUnitPrice().toPlainString()%> đ</td><td><%=quantities.get(p.getSparePartId())%></td><td><%=p.getStockQuantity()%></td></tr><%}%></table></div></div>
<div class="card"><h3>Nhân viên kỹ thuật</h3><p><%=tech==null?"Không xác định":Html.escape(tech.getEmployeeCode()+" - "+tech.getFullName())%></p></div>
<div class="card"><form method="post" action="<%=request.getContextPath()%>/sales/doSaveRepairOrder.jsp"><label>Mô tả yêu cầu sửa chữa (không bắt buộc)</label><textarea name="repairDescription" placeholder="Mô tả tình trạng xe hoặc yêu cầu của khách hàng..."><%=Html.escape(repairDescription)%></textarea>
<div class="actions"><button type="submit" class="success">Xác nhận tiếp nhận và lưu phiếu</button><a class="btn secondary" href="gdAssignTechnician.jsp">Quay lại</a></div></form></div>
</div>
<jsp:include page="/WEB-INF/footer.jsp"/>

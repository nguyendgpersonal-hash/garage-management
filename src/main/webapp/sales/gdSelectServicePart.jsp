<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.garage.dao.ServiceDAO,com.garage.dao.SparePartDAO,com.garage.model.Service,com.garage.model.SparePart,com.garage.util.Html,java.util.*" %>
<jsp:include page="/WEB-INF/header.jsp"><jsp:param name="title" value="Chọn dịch vụ và phụ tùng"/></jsp:include>
<%
if(session.getAttribute("selectedVehicle")==null){response.sendRedirect(request.getContextPath()+"/sales/gdRecordVehicle.jsp");return;}
String error=null;String keyword=request.getParameter("keyword");
List<Service> services=new ServiceDAO().searchByName(keyword==null?"":keyword);
List<SparePart> parts=new SparePartDAO().searchByName(keyword==null?"":keyword);
if("POST".equalsIgnoreCase(request.getMethod())){try{
 String[] serviceIds=request.getParameterValues("serviceIds");String[] partIds=request.getParameterValues("partIds");
 List<Integer> sids=new ArrayList<>();if(serviceIds!=null)for(String id:serviceIds)sids.add(Integer.parseInt(id));
 Map<Integer,Integer> quantities=new LinkedHashMap<>();if(partIds!=null)for(String id:partIds){int pid=Integer.parseInt(id);int qty=Integer.parseInt(request.getParameter("qty_"+pid));if(qty<=0)throw new IllegalArgumentException("Số lượng phụ tùng phải lớn hơn 0.");quantities.put(pid,qty);}
 if(sids.isEmpty()&&quantities.isEmpty())throw new IllegalArgumentException("Hãy chọn ít nhất một dịch vụ hoặc phụ tùng.");
 session.setAttribute("selectedServiceIds",sids);session.setAttribute("selectedPartQuantities",quantities);
 response.sendRedirect(request.getContextPath()+"/sales/gdAssignTechnician.jsp");return;
 }catch(Exception ex){error=ex.getMessage()==null?"Dữ liệu lựa chọn không hợp lệ.":ex.getMessage();}}
%>
<div class="container"><div class="step"><span>1. Khách hàng</span><span>2. Xe</span><span class="active">3. Dịch vụ & phụ tùng</span><span>4. Kỹ thuật viên</span><span>5. Xác nhận</span></div>
<h1 class="page-title">Lựa chọn dịch vụ và phụ tùng</h1><p class="sub">Chọn các hạng mục theo yêu cầu sửa chữa. Số lượng phụ tùng không được vượt quá tồn kho.</p>
<%if(error!=null){%><div class="alert error"><%=Html.escape(error)%></div><%}%>
<div class="card"><form method="get"><label>Tìm kiếm theo tên</label><div class="form-grid"><input name="keyword" placeholder="Nhập tên dịch vụ hoặc phụ tùng" value="<%=Html.escape(keyword)%>"><button type="submit">Tìm kiếm</button></div></form></div>
<form method="post">
<div class="card"><h3>Danh sách dịch vụ</h3><div class="table-wrap"><table><thead><tr><th>Chọn</th><th>Mã</th><th>Tên dịch vụ</th><th>Mô tả</th><th>Giá</th></tr></thead><tbody>
<%for(Service s:services){%><tr><td><input type="checkbox" name="serviceIds" value="<%=s.getServiceId()%>"></td><td>DV<%=s.getServiceId()%></td><td><%=Html.escape(s.getServiceName())%></td><td><%=Html.escape(s.getDescription())%></td><td class="price"><%=s.getServicePrice().toPlainString()%> đ</td></tr><%}%>
<%if(services.isEmpty()){%><tr><td colspan="5" class="muted">Không tìm thấy dịch vụ.</td></tr><%}%>
</tbody></table></div></div>
<div class="card"><h3>Danh sách phụ tùng</h3><div class="table-wrap"><table><thead><tr><th>Chọn</th><th>Mã</th><th>Tên phụ tùng</th><th>Đơn giá</th><th>Tồn kho</th><th>Số lượng dùng</th></tr></thead><tbody>
<%for(SparePart p:parts){%><tr><td><input type="checkbox" name="partIds" value="<%=p.getSparePartId()%>"></td><td>PT<%=p.getSparePartId()%></td><td><%=Html.escape(p.getPartName())%></td><td class="price"><%=p.getUnitPrice().toPlainString()%> đ</td><td><%=p.getStockQuantity()%></td><td><input style="max-width:90px" type="number" min="1" max="<%=p.getStockQuantity()%>" name="qty_<%=p.getSparePartId()%>" value="1"></td></tr><%}%>
<%if(parts.isEmpty()){%><tr><td colspan="6" class="muted">Không tìm thấy phụ tùng.</td></tr><%}%>
</tbody></table></div></div>
<div class="actions"><button type="submit">Xác nhận lựa chọn và tiếp tục</button><a class="btn secondary" href="gdRecordVehicle.jsp">Quay lại</a></div>
</form></div>
<jsp:include page="/WEB-INF/footer.jsp"/>

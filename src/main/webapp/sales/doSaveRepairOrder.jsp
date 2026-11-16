<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.garage.config.DBConnection,com.garage.dao.*,com.garage.model.*,java.sql.Connection,java.util.*,java.math.BigDecimal" %>
<%
request.setCharacterEncoding("UTF-8");
if (!"POST".equalsIgnoreCase(request.getMethod())) {
    response.sendRedirect(request.getContextPath() + "/sales/gdConfirmRepairReception.jsp");
} else {
    Customer customer = (Customer) session.getAttribute("selectedCustomer");
    Vehicle vehicle = (Vehicle) session.getAttribute("selectedVehicle");
    Integer salesId = (Integer) session.getAttribute("salesStaffId");
    Integer techId = (Integer) session.getAttribute("selectedTechnicianId");
    List<Integer> serviceIds = (List<Integer>) session.getAttribute("selectedServiceIds");
    Map<Integer, Integer> quantities = (Map<Integer, Integer>) session.getAttribute("selectedPartQuantities");
    String description = request.getParameter("repairDescription");
    if (description == null) description = (String) session.getAttribute("repairDescription");
    if (description == null) description = "";
    description = description.trim();
    session.setAttribute("repairDescription", description);

    if (customer == null || vehicle == null || salesId == null || techId == null
            || serviceIds == null || quantities == null) {
        session.setAttribute("receptionError", "Phiên tiếp nhận không đầy đủ dữ liệu. Vui lòng thực hiện lại.");
        response.sendRedirect(request.getContextPath() + "/sales/gdSalesHome.jsp");
    } else {
        int repairOrderId = 0;
        try (Connection c = DBConnection.getConnection()) {
            c.setAutoCommit(false);
            try {
                RepairOrder repairOrder = new RepairOrder();
                repairOrder.setCustomerId(customer.getPersonId());
                repairOrder.setVehicleId(vehicle.getVehicleId());
                repairOrder.setSalesStaffId(salesId);
                repairOrder.setTechnicianId(techId);
                repairOrder.setRepairDescription(description);
                repairOrderId = new RepairOrderDAO().createRepairOrder(c, repairOrder);

                Map<Integer, BigDecimal> servicePrices = new LinkedHashMap<>();
                ServiceDAO serviceDAO = new ServiceDAO();
                for (Integer id : serviceIds) {
                    com.garage.model.Service service = serviceDAO.findById(c, id);
                    if (service == null) {
                        throw new IllegalStateException("Một dịch vụ đã chọn không còn hoạt động.");
                    }
                    servicePrices.put(id, service.getServicePrice());
                }
                new RepairOrderServiceItemDAO().saveServiceItems(c, repairOrderId, servicePrices);

                Map<Integer, BigDecimal> partPrices = new LinkedHashMap<>();
                SparePartDAO partDAO = new SparePartDAO();
                for (Map.Entry<Integer, Integer> entry : quantities.entrySet()) {
                    SparePart part = partDAO.findById(c, entry.getKey());
                    if (part == null) {
                        throw new IllegalStateException("Một phụ tùng đã chọn không còn hoạt động.");
                    }
                    if (entry.getValue() == null || entry.getValue() <= 0) {
                        throw new IllegalArgumentException("Số lượng phụ tùng không hợp lệ.");
                    }
                    partDAO.decreaseStock(c, entry.getKey(), entry.getValue());
                    partPrices.put(entry.getKey(), part.getUnitPrice());
                }
                new RepairOrderPartItemDAO().savePartItems(c, repairOrderId, quantities, partPrices);
                c.commit();
            } catch (Exception ex) {
                c.rollback();
                throw ex;
            }

            session.setAttribute("savedRepairOrderId", repairOrderId);
            session.removeAttribute("selectedCustomer");
            session.removeAttribute("selectedVehicle");
            session.removeAttribute("selectedServiceIds");
            session.removeAttribute("selectedPartQuantities");
            session.removeAttribute("selectedTechnicianId");
            session.removeAttribute("selectedTechnicianName");
            session.removeAttribute("repairDescription");
            response.sendRedirect(request.getContextPath() + "/sales/gdRepairReceptionResult.jsp?success=1");
        } catch (Exception ex) {
            String errorMessage = ex.getMessage() == null
                    ? "Không thể lưu phiếu tiếp nhận." : ex.getMessage();
            session.setAttribute("receptionError", errorMessage);
            response.sendRedirect(request.getContextPath() + "/sales/gdRepairReceptionResult.jsp?success=0");
        }
    }
}
%>

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.garage.dao.AppointmentDAO,com.garage.model.Customer,com.garage.model.Appointment,java.time.LocalDate,java.time.LocalTime" %>
<%
try {
    Customer customer = (Customer) session.getAttribute("bookingCustomer");
    String date = (String) session.getAttribute("appointmentDate");
    String time = (String) session.getAttribute("appointmentTime");

    if (customer == null || date == null || time == null) {
        throw new IllegalStateException("Phiên đặt lịch đã hết hạn. Vui lòng đặt lịch lại.");
    }

    Appointment appointment = new Appointment();
    appointment.setCustomerId(customer.getPersonId());
    appointment.setAppointmentDate(LocalDate.parse(date));
    appointment.setAppointmentTime(LocalTime.parse(time));
    appointment = new AppointmentDAO().createAppointment(appointment);

    session.setAttribute("savedAppointmentId", appointment.getAppointmentId());
    session.removeAttribute("bookingCustomer");
    session.removeAttribute("appointmentDate");
    session.removeAttribute("appointmentTime");
    response.sendRedirect(request.getContextPath() + "/customer/gdAppointmentResult.jsp?success=1");
} catch (Exception ex) {
    String errorMessage = ex.getMessage() == null ? "Không thể lưu lịch hẹn." : ex.getMessage();
    session.setAttribute("bookingError", errorMessage);
    response.sendRedirect(request.getContextPath() + "/customer/gdAppointmentResult.jsp?success=0");
}
%>

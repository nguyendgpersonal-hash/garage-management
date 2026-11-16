<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.garage.util.Html" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title><%= Html.escape(request.getParameter("title") == null ? "Garage Management" : request.getParameter("title")) %></title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/style.css">
</head>
<body>
<div class="topbar"><div class="inner">
    <a class="brand" href="<%= request.getContextPath() %>/index.jsp">GARAGE MANAGEMENT</a>
    <nav class="nav">
        <a href="<%= request.getContextPath() %>/customer/gdSelectAppointmentTime.jsp">Đặt lịch hẹn</a>
        <a href="<%= request.getContextPath() %>/sales/gdSalesHome.jsp">Tiếp nhận xe</a>
    </nav>
</div></div>

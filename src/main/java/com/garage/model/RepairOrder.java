package com.garage.model;

import java.time.LocalDateTime;

public class RepairOrder {
    private int repairOrderId, customerId, vehicleId, salesStaffId, technicianId;
    private String repairDescription, status;
    private LocalDateTime receivedAt;
    public int getRepairOrderId() { return repairOrderId; }
    public void setRepairOrderId(int repairOrderId) { this.repairOrderId = repairOrderId; }
    public int getCustomerId() { return customerId; }
    public void setCustomerId(int customerId) { this.customerId = customerId; }
    public int getVehicleId() { return vehicleId; }
    public void setVehicleId(int vehicleId) { this.vehicleId = vehicleId; }
    public int getSalesStaffId() { return salesStaffId; }
    public void setSalesStaffId(int salesStaffId) { this.salesStaffId = salesStaffId; }
    public int getTechnicianId() { return technicianId; }
    public void setTechnicianId(int technicianId) { this.technicianId = technicianId; }
    public String getRepairDescription() { return repairDescription; }
    public void setRepairDescription(String repairDescription) { this.repairDescription = repairDescription; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public LocalDateTime getReceivedAt() { return receivedAt; }
    public void setReceivedAt(LocalDateTime receivedAt) { this.receivedAt = receivedAt; }
}

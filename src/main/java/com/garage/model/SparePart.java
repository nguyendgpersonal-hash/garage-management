package com.garage.model;

import java.math.BigDecimal;

public class SparePart {
    private int sparePartId, stockQuantity;
    private String partName, description;
    private BigDecimal unitPrice;
    public SparePart() {}
    public int getSparePartId() { return sparePartId; }
    public void setSparePartId(int sparePartId) { this.sparePartId = sparePartId; }
    public int getStockQuantity() { return stockQuantity; }
    public void setStockQuantity(int stockQuantity) { this.stockQuantity = stockQuantity; }
    public String getPartName() { return partName; }
    public void setPartName(String partName) { this.partName = partName; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public BigDecimal getUnitPrice() { return unitPrice; }
    public void setUnitPrice(BigDecimal unitPrice) { this.unitPrice = unitPrice; }
}

package com.garage.model;

import java.math.BigDecimal;

public class ServiceItem {
    private int serviceId;
    private String serviceName;
    private BigDecimal price;
    public ServiceItem(int serviceId, String serviceName, BigDecimal price) {
        this.serviceId = serviceId; this.serviceName = serviceName; this.price = price;
    }
    public int getServiceId() { return serviceId; }
    public String getServiceName() { return serviceName; }
    public BigDecimal getPrice() { return price; }
}

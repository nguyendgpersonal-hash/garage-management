CREATE DATABASE IF NOT EXISTS garage_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE garage_db;

SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS tblPayment;
DROP TABLE IF EXISTS tblRepairOrderServiceItem;
DROP TABLE IF EXISTS tblRepairOrderPartItem;
DROP TABLE IF EXISTS tblRepairOrder;
DROP TABLE IF EXISTS tblAppointment;
DROP TABLE IF EXISTS tblVehicle;
DROP TABLE IF EXISTS tblSparePartImportItem;
DROP TABLE IF EXISTS tblSparePartImport;
DROP TABLE IF EXISTS tblService;
DROP TABLE IF EXISTS tblSparePart;
DROP TABLE IF EXISTS tblSupplier;
DROP TABLE IF EXISTS tblEmployee;
DROP TABLE IF EXISTS tblPerson;
SET FOREIGN_KEY_CHECKS = 1;

CREATE TABLE tblPerson (
    personId INT AUTO_INCREMENT PRIMARY KEY,
    fullName VARCHAR(100) NOT NULL,
    address VARCHAR(255) NOT NULL,
    dateOfBirth DATE NULL,
    email VARCHAR(150) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    personType VARCHAR(20) NOT NULL,
    CONSTRAINT uq_person_phone UNIQUE (phone),
    CONSTRAINT ck_person_type CHECK (personType IN ('CUSTOMER','EMPLOYEE'))
) ENGINE=InnoDB;

CREATE TABLE tblEmployee (
    employeeId INT PRIMARY KEY,
    employeeCode VARCHAR(20) NOT NULL UNIQUE,
    jobPosition VARCHAR(30) NOT NULL,
    CONSTRAINT fk_employee_person FOREIGN KEY (employeeId) REFERENCES tblPerson(personId),
    CONSTRAINT ck_employee_position CHECK (jobPosition IN ('MANAGEMENT','WAREHOUSE','SALES','TECHNICIAN'))
) ENGINE=InnoDB;

CREATE TABLE tblVehicle (
    vehicleId INT AUTO_INCREMENT PRIMARY KEY,
    customerId INT NOT NULL,
    licensePlate VARCHAR(15) NOT NULL UNIQUE,
    brand VARCHAR(50) NOT NULL,
    model VARCHAR(50) NOT NULL,
    manufactureYear INT NOT NULL,
    color VARCHAR(30) NOT NULL,
    CONSTRAINT fk_vehicle_customer FOREIGN KEY (customerId) REFERENCES tblPerson(personId),
    CONSTRAINT ck_vehicle_year CHECK (manufactureYear BETWEEN 1950 AND 2100)
) ENGINE=InnoDB;

CREATE TABLE tblAppointment (
    appointmentId INT AUTO_INCREMENT PRIMARY KEY,
    customerId INT NOT NULL,
    appointmentDate DATE NOT NULL,
    appointmentTime TIME NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'BOOKED',
    createdAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_appointment_customer FOREIGN KEY (customerId) REFERENCES tblPerson(personId),
    CONSTRAINT ck_appointment_status CHECK (status IN ('BOOKED','CANCELLED','COMPLETED')),
    INDEX idx_appointment_date_time (appointmentDate, appointmentTime)
) ENGINE=InnoDB;

CREATE TABLE tblService (
    serviceId INT AUTO_INCREMENT PRIMARY KEY,
    serviceName VARCHAR(100) NOT NULL,
    description VARCHAR(255),
    servicePrice DECIMAL(12,2) NOT NULL,
    isActive BOOLEAN NOT NULL DEFAULT TRUE,
    CONSTRAINT ck_service_price CHECK (servicePrice >= 0)
) ENGINE=InnoDB;

CREATE TABLE tblSparePart (
    sparePartId INT AUTO_INCREMENT PRIMARY KEY,
    partName VARCHAR(100) NOT NULL,
    description VARCHAR(255),
    unitPrice DECIMAL(12,2) NOT NULL,
    stockQuantity INT NOT NULL DEFAULT 0,
    isActive BOOLEAN NOT NULL DEFAULT TRUE,
    CONSTRAINT ck_part_price CHECK (unitPrice >= 0),
    CONSTRAINT ck_part_stock CHECK (stockQuantity >= 0)
) ENGINE=InnoDB;

CREATE TABLE tblSupplier (
    supplierId INT AUTO_INCREMENT PRIMARY KEY,
    supplierName VARCHAR(150) NOT NULL,
    address VARCHAR(255),
    email VARCHAR(150),
    phone VARCHAR(20)
) ENGINE=InnoDB;

CREATE TABLE tblRepairOrder (
    repairOrderId INT AUTO_INCREMENT PRIMARY KEY,
    customerId INT NOT NULL,
    vehicleId INT NOT NULL,
    salesStaffId INT NOT NULL,
    technicianId INT NOT NULL,
    receivedAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    repairDescription VARCHAR(500),
    status VARCHAR(20) NOT NULL DEFAULT 'RECEIVED',
    CONSTRAINT fk_repair_customer FOREIGN KEY (customerId) REFERENCES tblPerson(personId),
    CONSTRAINT fk_repair_vehicle FOREIGN KEY (vehicleId) REFERENCES tblVehicle(vehicleId),
    CONSTRAINT fk_repair_sales FOREIGN KEY (salesStaffId) REFERENCES tblEmployee(employeeId),
    CONSTRAINT fk_repair_technician FOREIGN KEY (technicianId) REFERENCES tblEmployee(employeeId),
    CONSTRAINT ck_repair_status CHECK (status IN ('RECEIVED','IN_PROGRESS','COMPLETED','CANCELLED'))
) ENGINE=InnoDB;

CREATE TABLE tblRepairOrderServiceItem (
    serviceItemId INT AUTO_INCREMENT PRIMARY KEY,
    repairOrderId INT NOT NULL,
    serviceId INT NOT NULL,
    servicePrice DECIMAL(12,2) NOT NULL,
    CONSTRAINT fk_rosi_repair FOREIGN KEY (repairOrderId) REFERENCES tblRepairOrder(repairOrderId),
    CONSTRAINT fk_rosi_service FOREIGN KEY (serviceId) REFERENCES tblService(serviceId),
    CONSTRAINT uq_repair_service UNIQUE (repairOrderId, serviceId)
) ENGINE=InnoDB;

CREATE TABLE tblRepairOrderPartItem (
    partItemId INT AUTO_INCREMENT PRIMARY KEY,
    repairOrderId INT NOT NULL,
    sparePartId INT NOT NULL,
    quantity INT NOT NULL,
    unitPrice DECIMAL(12,2) NOT NULL,
    CONSTRAINT fk_ropi_repair FOREIGN KEY (repairOrderId) REFERENCES tblRepairOrder(repairOrderId),
    CONSTRAINT fk_ropi_part FOREIGN KEY (sparePartId) REFERENCES tblSparePart(sparePartId),
    CONSTRAINT uq_repair_part UNIQUE (repairOrderId, sparePartId),
    CONSTRAINT ck_repair_part_quantity CHECK (quantity > 0)
) ENGINE=InnoDB;

CREATE TABLE tblSparePartImport (
    importId INT AUTO_INCREMENT PRIMARY KEY,
    supplierId INT NOT NULL,
    warehouseStaffId INT NOT NULL,
    importDate DATE NOT NULL,
    CONSTRAINT fk_import_supplier FOREIGN KEY (supplierId) REFERENCES tblSupplier(supplierId),
    CONSTRAINT fk_import_employee FOREIGN KEY (warehouseStaffId) REFERENCES tblEmployee(employeeId)
) ENGINE=InnoDB;

CREATE TABLE tblSparePartImportItem (
    importItemId INT AUTO_INCREMENT PRIMARY KEY,
    sparePartImportId INT NOT NULL,
    sparePartId INT NOT NULL,
    quantity INT NOT NULL,
    importPrice DECIMAL(12,2) NOT NULL,
    CONSTRAINT fk_import_item_import FOREIGN KEY (sparePartImportId) REFERENCES tblSparePartImport(importId),
    CONSTRAINT fk_import_item_part FOREIGN KEY (sparePartId) REFERENCES tblSparePart(sparePartId),
    CONSTRAINT ck_import_quantity CHECK (quantity > 0)
) ENGINE=InnoDB;

CREATE TABLE tblPayment (
    paymentId INT AUTO_INCREMENT PRIMARY KEY,
    repairOrderId INT NOT NULL UNIQUE,
    amount DECIMAL(12,2) NOT NULL,
    paymentDate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    paymentMethod VARCHAR(30) NOT NULL,
    CONSTRAINT fk_payment_repair FOREIGN KEY (repairOrderId) REFERENCES tblRepairOrder(repairOrderId),
    CONSTRAINT ck_payment_amount CHECK (amount >= 0)
) ENGINE=InnoDB;

-- Dữ liệu mẫu: nhân viên bán hàng, kỹ thuật viên, dịch vụ, phụ tùng.
INSERT INTO tblPerson(fullName,address,dateOfBirth,email,phone,personType) VALUES
('Nguyễn Văn Bán Hàng','Hà Nội','1990-04-12','sales@garage.local','0900000001','EMPLOYEE'),
('Trần Văn Kỹ Thuật','Hà Nội','1992-08-20','tech1@garage.local','0900000002','EMPLOYEE'),
('Lê Văn Kỹ Thuật','Hà Nội','1994-02-15','tech2@garage.local','0900000003','EMPLOYEE'),
('Phạm Thị Quản Lý','Hà Nội','1988-11-05','manager@garage.local','0900000004','EMPLOYEE'),
('Hoàng Văn Kho','Hà Nội','1991-07-10','warehouse@garage.local','0900000005','EMPLOYEE');

INSERT INTO tblEmployee(employeeId,employeeCode,jobPosition) VALUES
(1,'NVBH001','SALES'),(2,'NVKT001','TECHNICIAN'),(3,'NVKT002','TECHNICIAN'),(4,'NVQL001','MANAGEMENT'),(5,'NVK001','WAREHOUSE');

INSERT INTO tblService(serviceName,description,servicePrice) VALUES
('Bảo dưỡng động cơ','Kiểm tra và bảo dưỡng động cơ',1500000),
('Thay dầu động cơ','Thay dầu và kiểm tra cơ bản',500000),
('Kiểm tra hệ thống phanh','Kiểm tra má phanh và dầu phanh',300000),
('Cân chỉnh bánh xe','Cân chỉnh góc đặt bánh xe',400000);

INSERT INTO tblSparePart(partName,description,unitPrice,stockQuantity) VALUES
('Lọc dầu','Lọc dầu động cơ',150000,30),
('Bugi','Bugi đánh lửa',200000,40),
('Lọc gió','Lọc gió động cơ',250000,25),
('Má phanh','Má phanh trước',650000,12);

INSERT INTO tblSupplier(supplierName,address,email,phone) VALUES
('Nhà cung cấp phụ tùng Minh Phát','Hà Nội','minhphat@example.local','02430000001');

INSERT INTO tblPerson(fullName,address,dateOfBirth,email,phone,personType) VALUES
('Nguyễn Văn A','Hà Nội','1995-05-15','nguyenvana@example.local','0987654321','CUSTOMER');

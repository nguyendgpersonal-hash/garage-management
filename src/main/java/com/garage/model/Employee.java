package com.garage.model;

public class Employee {
    private int employeeId;
    private String employeeCode, fullName, jobPosition;
    public Employee() {}
    public Employee(int employeeId, String employeeCode, String fullName, String jobPosition) {
        this.employeeId = employeeId; this.employeeCode = employeeCode; this.fullName = fullName; this.jobPosition = jobPosition;
    }
    public int getEmployeeId() { return employeeId; }
    public String getEmployeeCode() { return employeeCode; }
    public String getFullName() { return fullName; }
    public String getJobPosition() { return jobPosition; }
}

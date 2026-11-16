package com.garage.model;

import java.time.LocalDate;

public class Customer {
    private int personId;
    private String fullName, address, email, phone;
    private LocalDate dateOfBirth;

    public Customer() {}
    public Customer(int personId, String fullName, String address, LocalDate dateOfBirth, String email, String phone) {
        this.personId = personId; this.fullName = fullName; this.address = address;
        this.dateOfBirth = dateOfBirth; this.email = email; this.phone = phone;
    }
    public int getPersonId() { return personId; }
    public void setPersonId(int personId) { this.personId = personId; }
    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }
    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }
    public LocalDate getDateOfBirth() { return dateOfBirth; }
    public void setDateOfBirth(LocalDate dateOfBirth) { this.dateOfBirth = dateOfBirth; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }
}

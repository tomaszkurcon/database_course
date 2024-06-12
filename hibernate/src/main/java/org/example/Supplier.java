package org.example;

import jakarta.persistence.*;

import java.util.List;

@Entity
public class Supplier {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private int supplierID;
    private String companyName;
    private String street;
    private String city;
    @OneToMany(mappedBy = "supplier")
    private List<Product> products;
    public Supplier() {
    }
    public Supplier(String companyName, String street, String city) {
        this.companyName = companyName;
        this.street = street;
        this.city = city;
    }
    public Supplier(String companyName, String street, String city, List<Product> products) {
        this.companyName = companyName;
        this.street = street;
        this.city = city;
        this.products = products;
    }
    public void setProducts(List<Product> products) {
        this.products = products;
    }
}

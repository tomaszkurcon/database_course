package org.example;

import jakarta.persistence.*;

import java.util.ArrayList;
import java.util.List;

@Entity
public class Category {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private int categoryID;
    private String name;
    @OneToMany
    @JoinColumn(name = "categoryID")
    private List<Product> products;

    public Category() {
    }

    public Category(String name) {
        this.name = name;
        this.products = new ArrayList<>();
    }

    public List<Product> getProducts() {
        return products;
    }

    public void setProducts(List<Product> products) {
        this.products = products;
    }

    public String getName() {
        return name;
    }

    public int getCategoryID() {
        return categoryID;
    }
}

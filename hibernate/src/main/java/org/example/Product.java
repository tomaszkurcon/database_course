package org.example;

import jakarta.persistence.*;

@Entity
public class Product {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private int productID;
    private String productName;
    private int unitsInStock;

    @ManyToOne
    @JoinColumn(name = "supplierID")
    private Supplier supplier;

    @ManyToOne
    @JoinColumn(name = "categoryID")
    private Category category;
    public Product(){

    }
    public Product(String productName, int unitsInStock) {
        this.productName = productName;
        this.unitsInStock = unitsInStock;
    }
    public Product(String productName, int unitsInStock, Supplier supplier) {
        this.productName = productName;
        this.unitsInStock = unitsInStock;
        this.supplier = supplier;
    }
    public void setSupplier(Supplier supplier) {
        this.supplier = supplier;
    }
    public void setCategory(Category category) {
        this.category = category;
    }
    public Category getCategory() {
        return category;
    }
    public String getProductName() {
        return productName;
    }


}

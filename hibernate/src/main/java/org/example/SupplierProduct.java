package org.example;

import jakarta.persistence.*;

@Entity
public class SupplierProduct {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private int supplierProductID;

    @ManyToOne
    private Supplier supplier;
    @ManyToOne
    private Product product;
    public SupplierProduct(){

    }
    public SupplierProduct(Supplier supplier, Product product) {
        this.supplier = supplier;
        this.product = product;
    }
}

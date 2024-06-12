package org.example.exercises;

import org.example.Product;
import org.example.Supplier;
import org.example.SupplierProduct;
import org.hibernate.Session;
import org.hibernate.Transaction;

import java.util.List;

public class Exercise_2 {
    public static void runA(Session session){
        Product product1 = new Product("Kredki2_1", 3);
        Product product2 = new Product("Kredki2_2", 5);
        Product product3 = new Product("Kredki2_3", 4);

        Supplier supplier = new Supplier("Dell2", "1234 Dell Street", "Dell City");
        SupplierProduct supplierProduct1 = new SupplierProduct(supplier, product1);
        SupplierProduct supplierProduct2 = new SupplierProduct(supplier, product2);
        SupplierProduct supplierProduct3 = new SupplierProduct(supplier, product3);
        Transaction transaction = session.beginTransaction();
        session.save(product1);
        session.save(product2);
        session.save(product3);

        session.save(supplier);

        session.save(supplierProduct1);
        session.save(supplierProduct2);
        session.save(supplierProduct3);
        transaction.commit();
    }
    public static void runB(Session session){
        Product product1 = new Product("Kredki2_1", 3);
        Product product2 = new Product("Kredki2_2", 5);
        Product product3 = new Product("Kredki2_3", 4);
        List<Product> products = List.of(product1, product2, product3);
        Supplier supplier = new Supplier("Dell2", "1234 Dell Street", "Dell City");
        supplier.setProducts(products);
        Transaction transaction = session.beginTransaction();
        session.save(product1);
        session.save(product2);
        session.save(product3);
        session.save(supplier);
        transaction.commit();
    }
}

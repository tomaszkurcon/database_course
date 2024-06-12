package org.example.exercises;

import org.example.Product;
import org.example.Supplier;
import org.hibernate.Session;
import org.hibernate.Transaction;

import java.util.List;

public class Exercise_3 {
    public static void run(Session session){
        Product product1 = new Product("Kredki3_1", 3);
        Product product2 = new Product("Kredki3_2", 5);
        Product product3 = new Product("Kredki3_3", 4);

        Supplier supplier = new Supplier("Dell3", "1234 Dell Street", "Dell City");
        List<Product> products = List.of(product1, product2, product3);

        product1.setSupplier(supplier);
        product2.setSupplier(supplier);
        product3.setSupplier(supplier);

        supplier.setProducts(products);

        Transaction transaction = session.beginTransaction();
        session.save(product1);
        session.save(product2);
        session.save(product3);
        session.save(supplier);
        transaction.commit();
    }
}

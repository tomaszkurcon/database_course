package org.example.exercises;

import org.example.Category;
import org.example.Product;
import org.hibernate.Session;
import org.hibernate.Transaction;

import java.util.List;

public class Exercise_4 {
    public static void run(Session session){
        Category category1 = new Category("Kategoria4_1");
        Category category2 = new Category("Kategoria4_2");

        Product product1 = new Product("Kredki4_1", 3);
        Product product2 = new Product("Kredki4_2", 5);
        Product product3 = new Product("Kredki4_3", 4);

        category1.setProducts(List.of(product1, product2));

        product3.setCategory(category2);

        Transaction transaction = session.beginTransaction();
        session.save(category1);
        session.save(category2);

        session.save(product1);
        session.save(product2);
        session.save(product3);

        transaction.commit();

        session.refresh(category1);
        Category category = session.get(Category.class, category1.getCategoryID());
        System.out.println("Wydobycie produktów z kategorii: Kategoria4_1");
        category.getProducts().forEach(product -> System.out.println("Product name: " + product.getProductName() + "\nProduct Category: " + category1.getName()));
        System.out.println("Wydobycie kategorii do której należy produkt " + product3.getProductName());
        System.out.println(product3.getCategory().getName());
    }
}

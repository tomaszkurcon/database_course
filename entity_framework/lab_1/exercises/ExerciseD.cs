public class ExerciseD
{
    public void run(MyDbContext context)
    {
        //zad d
        //Dodanie produktów i faktur
        Product product1 = new Product { ProductName = "BallD1" };
        Product product2 = new Product { ProductName = "BallD2" };
        Product product3 = new Product { ProductName = "Balld3" };
        context.Products.AddRange(product1, product2, product3);
        context.SaveChanges();

        Invoice invoice1 = new Invoice { Products = new List<Product> { product1, product2 } };
        Invoice invoice2 = new Invoice { Products = new List<Product> { product2, product3 } };
        context.Invoices.Add(invoice1);
        context.Invoices.Add(invoice2);
        context.SaveChanges();

        // Produkty w danej fakturze
        int invoiceNumber = 1;

        var query = from inv in context.Invoices
                    where inv.InvoiceNumber == invoiceNumber
                    select inv.Products;
        Console.WriteLine("Produkty w fakturze o numerze: " + invoiceNumber);
        foreach (var product_list in query)
        {
            foreach (Product product in product_list)
            {
                Console.WriteLine(product.ProductName);
            }
        }

        //Faktury w ramach których został sprzedany dany produkt
        int productId = 2;

        var invoices = context.Invoices
                .Where(invoice => invoice.Products.Any(product => product.ProductId == productId))
                .ToList();

        Console.WriteLine("Faktury w ramach których został sprzedany produkt o id: "+productId);
        foreach (var invoice in invoices)
        {
            Console.WriteLine(invoice.InvoiceNumber);
        }
    }
}
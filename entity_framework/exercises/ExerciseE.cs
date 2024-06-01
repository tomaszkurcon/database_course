public class ExerciseE
{
    public void run(MyDbContext context)
    {
        var supplier1 = new Supplier { CompanyName = "Supplier1", Street = "Street1", City = "City1", ZipCode = "Zip1", BankAccountNumber = "1234567890" };
        var supplier2 = new Supplier { CompanyName = "Supplier2", Street = "Street2", City = "City2", ZipCode = "Zip2", BankAccountNumber = "0987654321" };
        var product1 = new Product { ProductName = "Product1", Supplier = supplier1 };
        supplier1.Products = new List<Product> { product1 };

        var customer1 = new Customer { CompanyName = "Customer1", Street = "Street3", City = "City3", ZipCode = "Zip3", Discount = 0.1m };
        var customer2 = new Customer { CompanyName = "Customer2", Street = "Street4", City = "City4", ZipCode = "Zip4", Discount = 0.2m };
        context.Companies.AddRange(supplier1, supplier2, customer1, customer2);
        context.SaveChanges();

        var suppliers = context.Companies.OfType<Supplier>().ToList();
        var customers = context.Companies.OfType<Customer>().ToList();

    
        foreach (var supplier in suppliers)
        {
            Console.WriteLine($"Supplier: {supplier.CompanyName}, Bank Account: {supplier.BankAccountNumber}");
        }

        foreach (var customer in customers)
        {
            Console.WriteLine($"Customer: {customer.CompanyName}, Discount: {customer.Discount}");
        }

    }
}
public class ExerciseB
{
    public void run(MyDbContext context)
    {
        // Utworzenie i dodanie dostawcy
        Supplier supplier = new Supplier { CompanyName = "SupplierB", City = "Warsaw", Street = "Marszalkowska 2" };
        Product product1 = new Product { ProductName = "BallB1" };
        Product product2 = new Product { ProductName = "BallB2" };
        Product product3 = new Product { ProductName = "BallB3" };
        supplier.Products = new List<Product> { product1, product2, product3 };
        context.Companies.Add(supplier);
        context.SaveChanges();
    }
}
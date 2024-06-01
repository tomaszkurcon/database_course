public class ExerciseC
{
    public void run(MyDbContext context)
    {
        Supplier supplier = new Supplier { CompanyName = "SupplierC", City = "Warsaw", Street = "Marszalkowska 3" };
        Product product1 = new Product { ProductName = "BallC1" };
        Product product2 = new Product { ProductName = "BallC2" };
        product1.Supplier = supplier;
        product2.Supplier = supplier;
        supplier.Products = new List<Product> { product1, product2 };

        context.Companies.Add(supplier);
        context.SaveChanges();
    }
}
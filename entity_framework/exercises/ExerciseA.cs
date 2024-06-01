public class ExerciseA
{
    public void run(MyDbContext context)
    {
        // Utworzenie i dodanie produktu
        Product product = new Product { ProductName = "Ball" };
        context.Products.Add(product);
        context.SaveChanges();
        // Utworzenie i dodanie dostawcy
        Supplier supplier = new Supplier { CompanyName = "Supplier1", City = "Warsaw", Street = "Marszalkowska 1" };
        context.Companies.Add(supplier);
        context.SaveChanges();

        // Znalezienie poprzedniego produktu i ustawienie dostawcy na wlasnie dodanego
        var lastProduct = context.Products.FirstOrDefault(p => p.ProductName == "Ball");
        if (lastProduct != null)
        {
            lastProduct.Supplier = supplier;
            context.SaveChanges();
        }
    }
}
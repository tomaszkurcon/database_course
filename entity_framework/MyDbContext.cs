 using Microsoft.EntityFrameworkCore;

public class MyDbContext : DbContext {
    public DbSet<Product> Products { get; set; }
    // public DbSet<Supplier> Suppliers { get; set; }
    public DbSet<Company> Companies { get; set; }
    public DbSet<Invoice> Invoices { get; set; }

    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder) {
        base.OnConfiguring(optionsBuilder);
        optionsBuilder.UseSqlite("Datasource=MyProductDatabase");
    }
      protected override void OnModelCreating(ModelBuilder modelBuilder) {
        base.OnModelCreating(modelBuilder);
        // exercise e
        // modelBuilder.Entity<Company>()
        //     .HasDiscriminator<string>("CompanyType")
        //     .HasValue<Supplier>("Supplier")
        //     .HasValue<Customer>("Customer");

        // exercise f
        modelBuilder.Entity<Supplier>().ToTable("Suppliers");
        modelBuilder.Entity<Customer>().ToTable("Customers");
    }
}

using System.ComponentModel.DataAnnotations.Schema;

public class Product
 {
    public int ProductId { get; set; }
    public String? ProductName { get; set; }
    public int UnitsInStock { get; set; }

    public int? SupplierId { get; set; }

    public Supplier? Supplier { get; set; }
    public ICollection<Invoice>? Invoices { get; set; }
 }

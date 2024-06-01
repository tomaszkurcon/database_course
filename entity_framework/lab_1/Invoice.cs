using System.ComponentModel.DataAnnotations;

public class Invoice{
    [Key]
    public int InvoiceNumber { get; set; }
    public int Quantity { get; set; }
    public required ICollection<Product> Products { get; set; } 
}


// public class Supplier {
//     public int SupplierId { get; set; }
//     public required String CompanyName { get; set; }
//     public String? Street { get; set; }
//     public String? City { get; set; }
//     // public List<Product>? Products { get; set; }
//     public ICollection<Product>? Products { get; set; }
    
// }

public class Supplier : Company
{
    public string? BankAccountNumber { get; set; }
    public ICollection<Product>? Products { get; set; }
}
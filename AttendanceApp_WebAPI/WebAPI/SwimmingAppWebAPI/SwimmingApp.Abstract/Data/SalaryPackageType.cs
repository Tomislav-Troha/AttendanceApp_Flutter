using System.ComponentModel.DataAnnotations.Schema;

namespace SwimmingApp.Abstract.Data
{
    public class SalaryPackageType
    {
        [Column("SalaryPackageID")]
        public int? ID { get; set; }
        public string? Name { get; set; }
        public string? Description { get; set; }
    }
}

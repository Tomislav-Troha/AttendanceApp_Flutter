using System.ComponentModel.DataAnnotations.Schema;

namespace SwimmingApp.Abstract.Data
{
    public class ContractType
    {
        [Column("ContractTypeID")]
        public int? ID { get; set; }
        public string? Name { get; set; }
        public string? Description { get; set; }
    }
}

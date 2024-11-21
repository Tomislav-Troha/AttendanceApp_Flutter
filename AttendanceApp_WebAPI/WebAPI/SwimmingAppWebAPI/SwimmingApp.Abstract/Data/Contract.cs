using System.ComponentModel.DataAnnotations.Schema;

namespace SwimmingApp.Abstract.Data
{
    public class Contract
    {
        [Column("ContractID")]
        public int? ID { get; set; }
        public int? UserID { get; set; }
        public int? UserRoleID { get; set; }
        public int? ContractTypeID { get; set; }
        public int? SalaryPackageID { get; set; }
        public int? JobRoleID { get; set; }
        public DateTime? StartDate { get; set; }
        public DateTime? ExpiryDate { get; set; }
    }
}

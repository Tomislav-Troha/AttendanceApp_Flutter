namespace SwimmingApp.Abstract.Data
{
    public class Contract
    {
        public int ContractID { get; set; }
        public int UserID { get; set; }
        public int UserRoleID { get; set; }
        public int ContractTypeID { get; set; }
        public int SalaryPackageID { get; set; }
        public int JobRoleID { get; set; }
        public DateTime? StartDate { get; set; }
        public DateTime? ExpiryDate { get; set; }



    }
}

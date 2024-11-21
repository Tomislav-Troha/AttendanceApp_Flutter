using SwimmingApp.Abstract.Data;

namespace SwimmingApp.Abstract.DataModel
{
    public class ContractModel : Contract
    {
        public ContractModel()
        {
            
        }
        public ContractModel(ContractModel? model)
        {
            UserModel = new UserModel(model?.UserModel);
            UserRoleModel = new UserRoleModel(model?.UserRoleModel);
            ContractTypeModel = new ContractTypeModel(model?.ContractTypeModel);
            SalaryPackageTypeModel = new SalaryPackageTypeModel(model?.SalaryPackageTypeModel);
            JobRoleModel = new JobRoleModel(model?.JobRoleModel);

        }

        public UserModel? UserModel { get; set; }
        public UserRoleModel? UserRoleModel { get; set; }
        public ContractTypeModel? ContractTypeModel { get; set; }
        public SalaryPackageTypeModel? SalaryPackageTypeModel { get; set; }
        public JobRoleModel? JobRoleModel { get; set; }

    }
}

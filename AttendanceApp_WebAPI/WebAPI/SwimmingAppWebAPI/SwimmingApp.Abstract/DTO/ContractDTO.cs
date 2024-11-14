using SwimmingApp.Abstract.DataModel;

namespace SwimmingApp.Abstract.DTO
{
    public class ContractDTO : ContractModel
    {
        public ContractDTO(ContractModel model) : base(model)
        {
            ContractID = model.ContractID;
            UserModel = model.UserModel != null ? new UserDTO(model.UserModel) : null;
            UserRoleModel = model.UserRoleModel != null ? new UserRoleDTO(model.UserRoleModel) : null;
            ContractTypeModel = model.ContractTypeModel != null ? new ContractTypeDTO(model.ContractTypeModel) : null;
            SalaryPackageTypeModel = model.SalaryPackageTypeModel != null ? new SalaryPackageTypeDTO(model.SalaryPackageTypeModel) : null;
            JobRoleModel = model.JobRoleModel != null ? new JobRoleDTO(model.JobRoleModel) : null;
            StartDate = model.StartDate;
            ExpiryDate = model.ExpiryDate;
        }
    }
}

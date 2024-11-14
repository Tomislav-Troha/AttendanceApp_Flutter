using SwimmingApp.Abstract.DataModel;

namespace SwimmingApp.Abstract.DTO
{
    public class SalaryPackageTypeDTO : SalaryPackageTypeModel
    {
        public SalaryPackageTypeDTO()
        {

        }
        public SalaryPackageTypeDTO(SalaryPackageTypeModel model) : base(model)
        {
            SalaryPackageID = model.SalaryPackageID;
            SalaryPackageName = model.SalaryPackageName;
            SalaryPackageDescription = model.SalaryPackageDescription;
        }
    }
}
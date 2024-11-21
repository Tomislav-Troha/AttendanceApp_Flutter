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
            ID = model.ID;
            Name = model.Name;
            Description = model.Description;
        }
    }
}
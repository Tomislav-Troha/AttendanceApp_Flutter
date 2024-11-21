using SwimmingApp.Abstract.DataModel;

namespace SwimmingApp.Abstract.DTO
{
    public class ContractTypeDTO : ContractTypeModel
    {
        public ContractTypeDTO()
        {
            
        }
        public ContractTypeDTO(ContractTypeModel model) : base(model)
        {
            ID = model.ID;
            Name = model.Name;
            Description = model.Description;
        }
    }
}
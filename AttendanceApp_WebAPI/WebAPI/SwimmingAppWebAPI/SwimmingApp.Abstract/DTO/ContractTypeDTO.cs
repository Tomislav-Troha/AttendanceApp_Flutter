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
            ContractTypeID = model.ContractTypeID;
            ContractTypeName = model.ContractTypeName;
            ContractTypeDescription = model.ContractTypeDescription;
        }
    }
}
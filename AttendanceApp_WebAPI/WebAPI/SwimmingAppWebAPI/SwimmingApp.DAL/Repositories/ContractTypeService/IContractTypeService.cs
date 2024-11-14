using SwimmingApp.Abstract.DataModel;

namespace SwimmingApp.DAL.Repositories.ContractTypeService
{
    public interface IContractTypeService
    {
        Task<IEnumerable<ContractTypeModel>> GetContractTypes();

        Task<ContractTypeModel> InsertContractType(ContractTypeModel model);
    }
}

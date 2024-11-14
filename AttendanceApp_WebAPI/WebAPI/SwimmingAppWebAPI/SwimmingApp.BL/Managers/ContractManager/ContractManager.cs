using SwimmingApp.Abstract.DataModel;
using SwimmingApp.Abstract.DTO;
using SwimmingApp.DAL.Repositories.EmployeeContract;

namespace SwimmingApp.BL.Managers.EmployeeContractManager
{
    public class ContractManager
    {
        private readonly IContractService _contractService;
        public ContractManager(IContractService contractService)
        {
            _contractService = contractService;
        }

        public async Task<ContractDTO?> InsertContract(ContractDTO? memberContractDTO, int? userID)
        {
            return await _contractService.InsertContract(memberContractDTO, userID);
        }

        public async Task<IEnumerable<ContractModel>?> GetContract(int? userID)
        {
            return await _contractService.GetContracts(userID);
        }

        public async Task<ContractDTO?> UpdateContract(ContractDTO employeeContractDTO)
        {
            return await _contractService.UpdateContract(employeeContractDTO);
        }
    }
}

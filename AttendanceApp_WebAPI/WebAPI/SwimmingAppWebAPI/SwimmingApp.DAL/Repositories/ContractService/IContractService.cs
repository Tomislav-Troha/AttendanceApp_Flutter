using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using SwimmingApp.Abstract.DataModel;
using SwimmingApp.Abstract.DTO;

namespace SwimmingApp.DAL.Repositories.EmployeeContract
{
    public interface IContractService
    {
        Task<ContractDTO> InsertContract(ContractDTO memberContractDTO, int userID);

        Task<IEnumerable<ContractModel>> GetContracts(int? userID);

        Task<ContractDTO> UpdateContract(ContractDTO memberContractDTO);
    }
}

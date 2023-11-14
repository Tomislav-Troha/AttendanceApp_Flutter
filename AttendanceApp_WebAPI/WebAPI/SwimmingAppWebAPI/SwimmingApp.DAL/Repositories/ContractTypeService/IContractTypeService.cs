using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using SwimmingApp.Abstract.DataModel;

namespace SwimmingApp.DAL.Repositories.ContractTypeService
{
    public interface IContractTypeService
    {
        Task<IEnumerable<ContractTypeModel>> GetContractTypes();

        Task<ContractTypeModel> InsertContractType(ContractTypeModel model);
    }
}

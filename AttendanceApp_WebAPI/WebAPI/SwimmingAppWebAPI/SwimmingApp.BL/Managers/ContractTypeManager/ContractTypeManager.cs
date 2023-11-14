using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using SwimmingApp.Abstract.DataModel;
using SwimmingApp.DAL.Repositories.ContractTypeService;

namespace SwimmingApp.BL.Managers.ContractTypeManager
{
    public class ContractTypeManager
    {
        private readonly IContractTypeService _contractTypeService;

        public ContractTypeManager(IContractTypeService contractTypeService)
        {
            _contractTypeService = contractTypeService;
        }

        public async Task<IEnumerable<ContractTypeModel>> GetContractTypes()
        {
            return await _contractTypeService.GetContractTypes();
        }

        public async Task<ContractTypeModel> InsertContractType(ContractTypeModel model)
        {
            return await _contractTypeService.InsertContractType(model);
        }
    }
}

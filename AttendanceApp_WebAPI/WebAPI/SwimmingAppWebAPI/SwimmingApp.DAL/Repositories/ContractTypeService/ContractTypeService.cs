using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Dapper;
using SwimmingApp.Abstract.DataModel;
using SwimmingApp.DAL.Core;

namespace SwimmingApp.DAL.Repositories.ContractTypeService
{
    public class ContractTypeService : IContractTypeService
    {
        private readonly IDbService _db;
        public ContractTypeService(IDbService db)
        {
            _db = db;
        }
        public async Task<IEnumerable<ContractTypeModel>> GetContractTypes()
        {
            return await _db.GetAsync<ContractTypeModel>("SELECT * FROM ContractType_Select()");
        }

        public async Task<ContractTypeModel> InsertContractType(ContractTypeModel model)
        {
            DynamicParameters param = new DynamicParameters();  
            param.Add("contractTypeName", model.ContractTypeName);
            param.Add("contractTypeDescription", model.ContractTypeDescription);

            await _db.InsertAsync("CALL ContractType_Insert(@contractTypeName, @contractTypeDescription)", param);

            return model;
        }
    }
}

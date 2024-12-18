﻿using Dapper;
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
            param.Add("contractTypeName", model.Name);
            param.Add("contractTypeDescription", model.Description);

            await _db.InsertAsync("CALL ContractType_Insert(@contractTypeName, @contractTypeDescription)", param);

            return model;
        }
    }
}

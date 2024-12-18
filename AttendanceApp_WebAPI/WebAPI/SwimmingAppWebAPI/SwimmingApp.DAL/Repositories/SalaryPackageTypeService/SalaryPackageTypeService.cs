﻿using Dapper;
using SwimmingApp.Abstract.DataModel;
using SwimmingApp.DAL.Core;

namespace SwimmingApp.DAL.Repositories.SalaryPackageTypeService
{
    public class SalaryPackageTypeService : ISalaryPackageTypeService
    {
        private readonly IDbService _db;

        public SalaryPackageTypeService(IDbService db)
        {
            _db = db;
        }

        public async Task<IEnumerable<SalaryPackageTypeModel>> GetSalaryPackageTypes()
        {
            return await _db.GetAsync<SalaryPackageTypeModel>("SELECT * FROM SalaryPackageType_Select()");
        }

        public async Task<SalaryPackageTypeModel> InsertSalaryPackageType(SalaryPackageTypeModel model)
        {
            DynamicParameters param = new DynamicParameters();
            param.Add("salaryPackageTypeName", model.Name);
            param.Add("salaryPackageTypeDescription", model.Description);

            await _db.InsertAsync("CALL SalaryPackageType_Insert(@salaryPackageTypeName, @salaryPackageTypeDescription)", param);

            return model;
        }
    }
}

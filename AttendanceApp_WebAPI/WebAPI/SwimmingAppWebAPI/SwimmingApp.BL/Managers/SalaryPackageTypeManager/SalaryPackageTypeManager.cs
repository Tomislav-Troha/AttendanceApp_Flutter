using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using SwimmingApp.Abstract.DataModel;
using SwimmingApp.DAL.Repositories.SalaryPackageTypeService;

namespace SwimmingApp.BL.Managers.SalaryPackageTypeManager
{
    public class SalaryPackageTypeManager
    {
        private readonly ISalaryPackageTypeService _salaryPackageTypeService;
        public SalaryPackageTypeManager(ISalaryPackageTypeService salaryPackageTypeService)
        {
            _salaryPackageTypeService = salaryPackageTypeService;
        }

        public async Task<IEnumerable<SalaryPackageTypeModel>> GetSalaryPackageTypes()
        {
            return await _salaryPackageTypeService.GetSalaryPackageTypes();
        }

        public async Task<SalaryPackageTypeModel> InsertSalaryPackageType(SalaryPackageTypeModel model)
        {
            return await _salaryPackageTypeService.InsertSalaryPackageType(model);
        }
    }

}

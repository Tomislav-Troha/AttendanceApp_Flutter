using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using SwimmingApp.Abstract.DataModel;

namespace SwimmingApp.DAL.Repositories.SalaryPackageTypeService
{
    public interface ISalaryPackageTypeService
    {
        Task<IEnumerable<SalaryPackageTypeModel>> GetSalaryPackageTypes();

        Task<SalaryPackageTypeModel> InsertSalaryPackageType(SalaryPackageTypeModel model);
    }
}

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using SwimmingApp.Abstract.DataModel;

namespace SwimmingApp.DAL.Repositories.JobRoleService
{
    public interface IJobRoleService
    {
        Task<IEnumerable<JobRoleModel>> GetJobRoles();

        Task<JobRoleModel> InsertJobRole(JobRoleModel model);
    }
}

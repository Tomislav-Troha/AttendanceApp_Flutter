using SwimmingApp.Abstract.DataModel;
using SwimmingApp.DAL.Repositories.ContractTypeService;
using SwimmingApp.DAL.Repositories.JobRoleService;

namespace SwimmingApp.BL.Managers.JobRoleManager
{
    public class JobRoleManager
    {
        private readonly IJobRoleService _jobRoleService;

        public JobRoleManager(IJobRoleService jobRoleService)
        {
            _jobRoleService = jobRoleService;
        }

        public async Task<IEnumerable<JobRoleModel>> GetJobRoles()
        {
            return await _jobRoleService.GetJobRoles();
        }

        public async Task<JobRoleModel> InsertJobRole(JobRoleModel model)
        {
            return await _jobRoleService.InsertJobRole(model);
        }
    }
}

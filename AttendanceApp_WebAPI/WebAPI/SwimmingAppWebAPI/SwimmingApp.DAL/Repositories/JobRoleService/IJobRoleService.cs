using SwimmingApp.Abstract.DataModel;

namespace SwimmingApp.DAL.Repositories.JobRoleService
{
    public interface IJobRoleService
    {
        Task<IEnumerable<JobRoleModel>> GetJobRoles();

        Task<JobRoleModel> InsertJobRole(JobRoleModel model);
    }
}

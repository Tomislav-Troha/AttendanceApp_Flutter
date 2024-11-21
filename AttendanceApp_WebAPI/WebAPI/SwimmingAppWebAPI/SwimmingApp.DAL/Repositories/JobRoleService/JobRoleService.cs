using Dapper;
using SwimmingApp.Abstract.DataModel;
using SwimmingApp.DAL.Core;

namespace SwimmingApp.DAL.Repositories.JobRoleService
{
    public class JobRoleService : IJobRoleService
    {
        private readonly IDbService _db;
        public JobRoleService(IDbService db)
        {
            _db = db;
        }

        public async Task<IEnumerable<JobRoleModel>> GetJobRoles()
        {
            return await _db.GetAsync<JobRoleModel>("SELECT * FROM JobRole_Select()");
        }

        public async Task<JobRoleModel> InsertJobRole(JobRoleModel model)
        {
            DynamicParameters param = new DynamicParameters();
            param.Add("jobRoleName", model.Name);
            param.Add("jobRoleDescription", model.Description);

            await _db.InsertAsync("CALL JobRole_Insert(@jobRoleName, @jobRoleDescription)", param);

            return model;
        }
    }
}

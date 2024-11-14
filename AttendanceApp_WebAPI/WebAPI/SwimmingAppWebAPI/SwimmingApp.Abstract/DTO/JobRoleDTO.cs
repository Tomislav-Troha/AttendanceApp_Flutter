using SwimmingApp.Abstract.DataModel;

namespace SwimmingApp.Abstract.DTO
{
    internal class JobRoleDTO : JobRoleModel
    {
        public JobRoleDTO()
        {

        }
        public JobRoleDTO(JobRoleModel model) : base(model)
        {
            JobRoleID = model.JobRoleID;
            JobRoleName = model.JobRoleName;
            JobRoleDescription = model.JobRoleDescription;
        }
    }
}
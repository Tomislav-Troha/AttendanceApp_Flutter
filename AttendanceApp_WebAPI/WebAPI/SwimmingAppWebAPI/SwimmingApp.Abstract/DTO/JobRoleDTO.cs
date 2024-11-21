using SwimmingApp.Abstract.DataModel;

namespace SwimmingApp.Abstract.DTO
{
    public class JobRoleDTO : JobRoleModel
    {
        public JobRoleDTO()
        {
            
        }
        public JobRoleDTO(JobRoleModel model) : base(model)
        {
            ID = model.ID;
            Name = model.Name;
            Description = model.Description;
        }
    }
}
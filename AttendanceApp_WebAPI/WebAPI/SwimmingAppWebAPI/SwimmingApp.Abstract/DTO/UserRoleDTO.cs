using SwimmingApp.Abstract.DataModel;

namespace SwimmingApp.Abstract.DTO
{
    public class UserRoleDTO : UserRoleModel
    {
        public UserRoleDTO()
        {
            
        }
        public UserRoleDTO(UserRoleModel? userRoleModel) : base(userRoleModel)
        {
            ID = userRoleModel?.ID;
            Name = userRoleModel?.Name;
            Description = userRoleModel?.Description;
        }
    }
}

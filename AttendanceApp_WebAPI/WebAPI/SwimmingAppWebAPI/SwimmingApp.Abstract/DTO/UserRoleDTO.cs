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
            RoleId = userRoleModel?.RoleId;
            RoleName = userRoleModel?.RoleName;
            RoleDesc = userRoleModel?.RoleDesc;
        }
    }
}

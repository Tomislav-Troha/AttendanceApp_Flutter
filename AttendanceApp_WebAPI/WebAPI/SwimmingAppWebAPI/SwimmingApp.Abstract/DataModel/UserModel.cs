using SwimmingApp.Abstract.Data;

namespace SwimmingApp.Abstract.DataModel
{
    public class UserModel : User
    {
        public UserModel()
        {
            UserRoleModel = new UserRoleModel();
        }
        public UserModel(UserModel? userModel)
        {
            UserRoleModel = new UserRoleModel(userModel?.UserRoleModel);
        }

        public UserRoleModel? UserRoleModel { get; set; }
    }
}

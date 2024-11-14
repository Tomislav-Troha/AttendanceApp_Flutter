using SwimmingApp.Abstract.Data;

namespace SwimmingApp.Abstract.DataModel
{
    public class UserRegisterModel : UserRegister
    {
        public UserRegisterModel(UserRegisterModel userRegisterModel)
        {
            UserRole = new UserRoleModel(userRegisterModel.UserRole);
        }

        public UserRegisterModel()
        {
            UserRole = new UserRoleModel();
        }
        public UserRoleModel UserRole { get; set; }
    }
}

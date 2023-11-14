using SwimmingApp.Abstract.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

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

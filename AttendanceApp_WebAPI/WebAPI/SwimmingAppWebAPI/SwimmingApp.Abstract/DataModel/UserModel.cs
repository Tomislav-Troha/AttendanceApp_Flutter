using SwimmingApp.Abstract.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SwimmingApp.Abstract.DataModel
{
    public class UserModel : User
    {

        public UserModel()
        {
            UserRoleModel = new UserRoleModel();
        }
        public UserModel(UserModel userModel)
        {
            UserRoleModel = new UserRoleModel(userModel.UserRoleModel);
        }

        public UserRoleModel UserRoleModel { get; set; }  
    }
}

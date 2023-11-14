using SwimmingApp.Abstract.DataModel;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SwimmingApp.Abstract.DTO
{
    public class UserDTO : UserModel
    {
        public UserDTO(UserModel userModel)
        {
            UserId = userModel.UserId;
            Name = userModel.Name;   
            Surname = userModel.Surname;
            Email = userModel.Email;
            Username = userModel.Username;
            Password = userModel.Password;
            Addres = userModel.Addres;
            UserRoleModel = userModel.UserRoleModel != null ? new UserRoleDTO(userModel.UserRoleModel) : null;
            ProfileImage = userModel.ProfileImage;
        }

        public UserDTO()
        {

        }
    }
}

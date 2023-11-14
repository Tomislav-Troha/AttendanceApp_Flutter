using SwimmingApp.Abstract.Data;
using SwimmingApp.Abstract.DataModel;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SwimmingApp.Abstract.DTO
{
    public class UserRegisterDTO : UserRegisterModel
    {
        public UserRegisterDTO(UserRegisterModel userRegisterModel)
        {
            Name= userRegisterModel.Name;
            Surname= userRegisterModel.Surname;
            Email= userRegisterModel.Email;
            Password= userRegisterModel.Password;
            Username= userRegisterModel.Username;
            Addres= userRegisterModel.Addres;
            UserRole= userRegisterModel.UserRole != null ? new UserRoleDTO(userRegisterModel.UserRole) : null;
        }

        public UserRegisterDTO()
        {

        }
      
    }
}

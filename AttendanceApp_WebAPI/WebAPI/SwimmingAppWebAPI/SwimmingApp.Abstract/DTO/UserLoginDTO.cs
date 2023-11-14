using SwimmingApp.Abstract.DataModel;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SwimmingApp.Abstract.DTO
{
    public class UserLoginDTO : UserLoginModel
    {
        public UserLoginDTO(UserLoginModel model)
        {
            Email = model.Email;
            Username = model.Username;
            Password = model.Password;
            SessionUuid = model.SessionUuid;
        }

        public UserLoginDTO()
        {

        }
    }
}

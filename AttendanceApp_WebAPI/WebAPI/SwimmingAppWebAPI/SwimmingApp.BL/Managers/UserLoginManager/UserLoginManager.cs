using SwimmingApp.Abstract.DataModel;
using SwimmingApp.Abstract.DTO;
using SwimmingApp.DAL.Repositories.UserLoginService;
using SwimmingApp.DAL.Repositories.UserRegisterService;
using SwimmingApp.DAL.Repositories.UserService;
using SwimmingApp.DAL.Responses;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SwimmingApp.BL.Managers.UserLoginManager
{
    public class UserLoginManager
    {
        private readonly IUserLoginService _userLogin;

        public UserLoginManager(IUserLoginService userLogin)
        {
            _userLogin = userLogin;
        }

        public async Task<UserLoginResponse> LoginUser(UserLoginDTO userLoginDTO)
        {
            return await _userLogin.UserLogin(userLoginDTO); 
        }
    }
}

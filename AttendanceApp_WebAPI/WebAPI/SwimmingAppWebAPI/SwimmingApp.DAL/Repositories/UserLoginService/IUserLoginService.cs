using SwimmingApp.Abstract.DTO;
using SwimmingApp.DAL.Responses;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SwimmingApp.DAL.Repositories.UserLoginService
{
    public interface IUserLoginService
    {
        Task<UserLoginResponse> UserLogin(UserLoginDTO request);
        Task<UserLoginResponse> Validate(UserLoginDTO request);
    }
}

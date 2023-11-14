using SwimmingApp.Abstract.DTO;
using SwimmingApp.DAL.Responses;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SwimmingApp.DAL.Repositories.UserRegisterService
{
    public interface IUserRegisterService
    {
        Task<UserRegisterResponse> UserRegister(UserRegisterDTO request, int adminID);

        Task<UserRegisterResponse> Validate(UserRegisterDTO request);
    }
}

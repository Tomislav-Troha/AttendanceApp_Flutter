using SwimmingApp.Abstract.DTO;
using SwimmingApp.DAL.Responses;

namespace SwimmingApp.DAL.Repositories.UserLoginService
{
    public interface IUserLoginService
    {
        Task<UserLoginResponse> UserLogin(UserLoginDTO request);
        Task<UserLoginResponse> Validate(UserLoginDTO request);
    }
}

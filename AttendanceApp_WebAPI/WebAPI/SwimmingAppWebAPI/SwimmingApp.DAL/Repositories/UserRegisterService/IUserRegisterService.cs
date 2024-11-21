using SwimmingApp.Abstract.DTO;
using SwimmingApp.DAL.Responses;

namespace SwimmingApp.DAL.Repositories.UserRegisterService
{
    public interface IUserRegisterService
    {
        Task<UserRegisterResponse> UserRegister(UserRegisterDTO request);
        Task<UserRegisterResponse> Validate(UserRegisterDTO request);
    }
}

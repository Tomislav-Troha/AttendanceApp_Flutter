using SwimmingApp.Abstract.DTO;
using SwimmingApp.DAL.Responses;

namespace SwimmingApp.DAL.Repositories.UserRegisterService
{
    public interface IUserRegisterService
    {
        Task<UserRegisterResponse> UserRegister(UserRegisterDTO request, int adminID);

        Task<UserRegisterResponse> Validate(UserRegisterDTO request);
    }
}

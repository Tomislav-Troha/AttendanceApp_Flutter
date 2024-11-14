using SwimmingApp.Abstract.DTO;
using SwimmingApp.DAL.Responses;

namespace SwimmingApp.DAL.Repositories.PaswordResetService
{
    public interface IPasswordResetService
    {
        Task<PasswordResetResponse> PasswordReset(PasswordResetDTO response);
    }
}

using SwimmingApp.Abstract.DTO;
using SwimmingApp.DAL.Repositories.PaswordResetService;
using SwimmingApp.DAL.Responses;

namespace SwimmingApp.BL.Managers.ChangePasswordManager
{
    public class PasswordResetManager
    {
        private readonly IPasswordResetService _passwordResetService;

        public PasswordResetManager(IPasswordResetService passwordResetService)
        {
            _passwordResetService = passwordResetService;
        }

        public async Task<PasswordResetResponse> ResetPassword(PasswordResetDTO response)
        {
            return await _passwordResetService.PasswordReset(response);
        }
    }
}

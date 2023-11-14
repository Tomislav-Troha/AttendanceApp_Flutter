using FluentValidation;
using SwimmingApp.Abstract.DTO;
using SwimmingApp.DAL.Repositories.UserService;
using System.Collections;
using System.Security.Cryptography;
using System.Text;

namespace SwimmingApp.DAL.Validators
{
    public class PasswordResetValidator : AbstractValidator<PasswordResetDTO>
    {
        private readonly IUserService _userService;
        private readonly byte[] _newPassword;
        public PasswordResetValidator(IUserService userService)
        {
            _userService = userService;

            RuleFor(x => x.Email).NotEmpty().WithMessage("E-mail is required");
            RuleFor(y => y).MustAsync(VerifyEmail).WithMessage("E-mail is incorrect");
            RuleFor(y => y).MustAsync(NewPasswordIsLikeOldPassword).WithMessage("New password must be different");
        }

        private async Task<bool> VerifyEmail(PasswordResetDTO resetPassword, CancellationToken token)
        {
            var email = await _userService.GetUserByEmail(resetPassword.Email);

            if (email == null)
            {
                return false;
            }
            return true;
        }

        private async Task<bool> NewPasswordIsLikeOldPassword(PasswordResetDTO resetPassword, CancellationToken token)
        {
            if (!await VerifyEmail(resetPassword, token))
            {
                return true;
            }

            var user = await _userService.GetUserLoginData(resetPassword.Email);

            if (user != null)
            {
                var sha256 = SHA256.Create();
                byte[] oldPassword = sha256.ComputeHash(Encoding.UTF8.GetBytes((resetPassword.Password) + user.Salt));

                bool newPasswordIsLikeOldPassword = StructuralComparisons.StructuralEqualityComparer.Equals(oldPassword, user.Password);

                if (newPasswordIsLikeOldPassword)
                {
                    return false; // new password is the same as the old password
                }
                else return true; // new password is not the same as the old password
            }
            return false;
        }


    }
}

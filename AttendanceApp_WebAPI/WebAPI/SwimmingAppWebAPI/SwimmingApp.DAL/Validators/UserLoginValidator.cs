using System.Collections;
using System.Security.Cryptography;
using System.Text;
using FluentValidation;
using SwimmingApp.Abstract.DTO;
using SwimmingApp.DAL.Repositories.UserService;

namespace SwimmingApp.DAL.Validators
{
    public class UserLoginValidator : AbstractValidator<UserLoginDTO>
    {
        private readonly IUserService _userService;

        public UserLoginValidator(IUserService userService)
        {
            _userService = userService;

            RuleFor(x => x.Email).NotEmpty().NotNull().WithMessage("E-mail is required");
            RuleFor(x => x.Password).NotEmpty().NotNull().WithMessage("Password is required");
            RuleFor(e => e).MustAsync(VerifyLogin).WithMessage("E-mail or password is incorrect");
            RuleFor(e => e).MustAsync(IsUserSet).WithMessage("Contact your supervisor to activate your account");
        }

        private async Task<bool> IsUserSet(UserLoginDTO? loginDto, CancellationToken token)
        {
            if (string.IsNullOrEmpty(loginDto?.Email))
                return false;

            var user = await _userService.GetUserLoginData(loginDto.Email);

            if (user != null)
            {
                var sha256 = SHA256.Create();

                byte[] password = sha256.ComputeHash(Encoding.UTF8.GetBytes(loginDto.Password + user.Salt));
                bool passwordIsTrue = StructuralComparisons.StructuralEqualityComparer.Equals(password, user.Password);
                if (passwordIsTrue)
                {
                    if (user.UserRoleModel == null)
                        return false;
                    else return true;
                }
                else return true;
            }
            return true;
        }
        private async Task<bool> VerifyLogin(UserLoginDTO? loginDTO, CancellationToken token)
        {
            var user = await _userService.GetUserLoginData(loginDTO?.Email);

            if (user != null)
            {
                var sha256 = SHA256.Create();

                byte[] password = sha256.ComputeHash(Encoding.UTF8.GetBytes((loginDTO?.Password) + user?.Salt));
                bool passwordIsTrue = StructuralComparisons.StructuralEqualityComparer.Equals(password, user?.Password);
                if (passwordIsTrue) { return true; }
            }
            else return false;

            return false;
        }

    }
}

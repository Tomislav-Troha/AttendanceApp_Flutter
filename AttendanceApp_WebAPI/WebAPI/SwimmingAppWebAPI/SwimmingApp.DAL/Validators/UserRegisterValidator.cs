using FluentValidation;
using SwimmingApp.Abstract.DTO;
using SwimmingApp.DAL.Repositories.UserService;

namespace SwimmingApp.DAL.Validators
{
    public class UserRegisterValidator : AbstractValidator<UserRegisterDTO>
    {
        private readonly IUserService _userService;

        public UserRegisterValidator(IUserService userService)
        {
            _userService = userService;

            RuleFor(x => x.Email).NotNull().NotEmpty().WithMessage("Email is required");
        }
    }
}

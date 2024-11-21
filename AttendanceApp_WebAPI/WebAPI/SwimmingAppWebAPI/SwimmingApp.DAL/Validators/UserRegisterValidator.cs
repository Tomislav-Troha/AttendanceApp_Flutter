using FluentValidation;
using SwimmingApp.Abstract.DTO;

namespace SwimmingApp.DAL.Validators
{
    public class UserRegisterValidator : AbstractValidator<UserRegisterDTO>
    {
        public UserRegisterValidator()
        {
            RuleFor(x => x.Email).NotNull().NotEmpty().WithMessage("Email is required");
        }
    }
}

using SwimmingApp.Abstract.DataModel;
using SwimmingApp.Abstract.DTO;
using SwimmingApp.BL.Utils;
using SwimmingApp.DAL.Repositories.UserService;
using SwimmingApp.DAL.Responses;
using SwimmingApp.DAL.Validators;

namespace SwimmingApp.DAL.Repositories.UserRegisterService
{
    public class UserRegisterService : IUserRegisterService
    {
        private readonly IUserService _userService;
        public UserRegisterService(IUserService userService)
        {
            _userService = userService;
        }

        public async Task<UserRegisterResponse> UserRegister(UserRegisterDTO? request)
        {
            var response = await Validate(request);

            if (response.Success)
            {
                //byte[] activationToken = PasswordManager.GenerateActivationToken();

                //string encodedToken = WebEncoders.Base64UrlEncode(activationToken);
                PasswordManager passwordManager = new PasswordManager();
                byte[] salt = passwordManager.GenerateSaltHash();
                byte[] hashPassword = passwordManager.GeneratePasswordHash(request?.Password, salt);

                var userModel = new UserModel
                {
                    Name = request?.Name,
                    Surname = request?.Surname,
                    Email = request?.Email,
                    Password = hashPassword,
                    Salt = salt,
                    Username = request?.Username,
                    Address = request?.Address
                };

                //admin role
                int? userRoleID = null;
                if (await _userService.CheckIfFirstEver())
                    userRoleID = 1;

                await _userService.InsertUser(userModel, userRoleID);
            }

            return response;
        }

        public async Task<UserRegisterResponse> Validate(UserRegisterDTO? request)
        {
            ArgumentNullException.ThrowIfNull(request);

            var response = new UserRegisterResponse();

            var user = await _userService.GetUserByEmail(request?.Email);

            if (!string.IsNullOrEmpty(user?.Email))
            {
                response.Success = false;
                response.Errors.Add("E-mail already exists.");

                return response;
            };

            var validator = new UserRegisterValidator();

            var validatorResult = await validator.ValidateAsync(request!);

            if (validatorResult.Errors.Count > 0)
            {
                response.Success = false;
                foreach (var error in validatorResult.Errors)
                {
                    response.Errors.Add(error.ErrorMessage);
                }
            }

            return response;
        }
    }
}

using Microsoft.Extensions.Configuration;
using SwimmingApp.Abstract.DTO;
using SwimmingApp.BL.Utils;
using SwimmingApp.DAL.Repositories.UserService;
using SwimmingApp.DAL.Responses;
using SwimmingApp.DAL.Validators;

namespace SwimmingApp.DAL.Repositories.UserLoginService
{
    public class UserLoginService : IUserLoginService
    {
        private readonly IUserService _userService;
        private readonly IConfiguration _configuration;

        public UserLoginService(IUserService userService, IConfiguration configuration)
        {
            _userService = userService;
            _configuration = configuration;
        }

        public async Task<UserLoginResponse> UserLogin(UserLoginDTO? request)
        {
            var response = await Validate(request);

            if (response.Success)
            {
                var userModel = await _userService.GetUserByEmail(request?.Email);

                if (userModel == null)
                {
                    response.Success = false;
                    response.Errors.Add("User not found");
                    return response;
                }

                //dodatno mozda jos uvesti UserLoginHistory

                response.Token = TokenGenerator.CreateToken(userModel, _configuration);
            }

            return response;
        }

        public async Task<UserLoginResponse> Validate(UserLoginDTO? request)
        {
            if (request == null)
                throw new ArgumentNullException(nameof(request));

            var response = new UserLoginResponse();
            var validator = new UserLoginValidator(_userService);
            var validatorResult = await validator.ValidateAsync(request);

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

using SwimmingApp.Abstract.DataModel;
using SwimmingApp.Abstract.DTO;
using SwimmingApp.BL.Utils;
using SwimmingApp.DAL.Repositories.UserService;
using SwimmingApp.DAL.Responses;
using SwimmingApp.DAL.Validators;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SwimmingApp.DAL.Repositories.PaswordResetService
{
    public class PasswordResetService : IPasswordResetService
    {
        private readonly IUserService _userService;

        public PasswordResetService(IUserService userService)
        {
            _userService = userService;
        }
        public async Task<PasswordResetResponse> PasswordReset(PasswordResetDTO request)
        {

            PasswordManager passwordManager = new PasswordManager();


            var response = await Validate(request);

            if (response.Success)
            {
                byte[] salt = passwordManager.GenerateSaltHash();
                byte[] newHashPassword = passwordManager.GeneratePasswordHash(request.Password, salt);

                var userModel = new UserModel
                {
                    Email = request.Email,
                    Password = newHashPassword,
                    Salt = salt,
                };

                await _userService.UpdateUserPassword(userModel);
            }

            return response;
        }


        private async Task<PasswordResetResponse> Validate(PasswordResetDTO request)
        {
            var response = new PasswordResetResponse();
            var validator = new PasswordResetValidator(_userService);
            var validatorResult = await validator.ValidateAsync(request);


            if (validatorResult.Errors.Count > 0)
            {
                response.Success = false;
                foreach (var error in validatorResult.Errors)
                    response.Errors.Add(error.ErrorMessage);
            }
            return response;
        }

    }
}

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
        private readonly IUserService _iuserService;
        public UserRegisterService(IUserService userService)
        {
            _iuserService = userService;
        }

        public async Task<UserRegisterResponse> UserRegister(UserRegisterDTO request, int adminID)
        {
            var response = await Validate(request);

            if(response.Success)
            {
                //byte[] activationToken = PasswordManager.GenerateActivationToken();

                //string encodedToken = WebEncoders.Base64UrlEncode(activationToken);
                PasswordManager passwordManager = new PasswordManager();
                byte[] salt = passwordManager.GenerateSaltHash();
                byte[] hashPassword = passwordManager.GeneratePasswordHash(request.Password, salt);

                var userModel = new UserModel
                {
                    Name = request.Name,
                    Surname = request.Surname,
                    Email = request.Email,
                    Password = hashPassword,
                    Salt = salt,
                    Username = request.Username,
                    Addres = request.Addres
                };

                await _iuserService.InsertUser(userModel);
            }

            return response;
        }

        public async Task<UserRegisterResponse> Validate(UserRegisterDTO request)
        {
            var response = new UserRegisterResponse();
            bool userExist = false;
            var userEmail = await _iuserService.GetUserByEmail(request.Email);

            if(userEmail != null) 
                userExist = true;

            var validator = new UserRegisterValidator(_iuserService);
            var validatorResult = await validator.ValidateAsync(request);

            if(validatorResult.Errors.Count > 0)
            {
                response.Success = false;
                foreach (var error in validatorResult.Errors)
                {
                    response.Errors.Add(error.ErrorMessage);
                }
            }
            else if(userExist == true)
            {
                response.Success = false;
                response.Errors.Add("E-mail već postoji");
            }

            return response;
        }
    }
}

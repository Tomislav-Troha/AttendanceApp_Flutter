using SwimmingApp.Abstract.DataModel;

namespace SwimmingApp.Abstract.DTO
{
    public class UserLoginDTO : UserLoginModel
    {
        public UserLoginDTO()
        {
            
        }
        public UserLoginDTO(UserLoginModel model)
        {
            Email = model.Email;
            Username = model.Username;
            Password = model.Password;
            SessionUuid = model.SessionUuid;
        }
    }
}

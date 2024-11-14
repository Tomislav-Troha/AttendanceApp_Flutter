using SwimmingApp.Abstract.DataModel;

namespace SwimmingApp.Abstract.DTO
{
    public class UserRegisterDTO : UserRegisterModel
    {
        public UserRegisterDTO(UserRegisterModel? userRegisterModel)
        {
            Name = userRegisterModel?.Name;
            Surname = userRegisterModel?.Surname;
            Email = userRegisterModel?.Email;
            Password = userRegisterModel?.Password;
            Username = userRegisterModel?.Username;
            Addres = userRegisterModel?.Addres;
            UserRole = userRegisterModel?.UserRole ?? new UserRoleDTO(userRegisterModel?.UserRole);
        }

        public UserRegisterDTO()
        {

        }

    }
}

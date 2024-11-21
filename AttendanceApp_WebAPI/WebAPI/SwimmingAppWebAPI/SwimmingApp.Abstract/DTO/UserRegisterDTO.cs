using SwimmingApp.Abstract.DataModel;

namespace SwimmingApp.Abstract.DTO
{
    public class UserRegisterDTO : UserRegisterModel
    {
        public UserRegisterDTO()
        {
            
        }
        public UserRegisterDTO(UserRegisterModel? userRegisterModel)
        {
            Name = userRegisterModel?.Name;
            Surname = userRegisterModel?.Surname;
            Email = userRegisterModel?.Email;
            Password = userRegisterModel?.Password;
            Username = userRegisterModel?.Username;
            Address = userRegisterModel?.Address;
            UserRole = userRegisterModel?.UserRole ?? new UserRoleDTO(userRegisterModel?.UserRole);
        }
    }
}

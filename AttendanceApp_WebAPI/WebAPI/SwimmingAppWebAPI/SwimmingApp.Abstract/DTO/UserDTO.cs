using SwimmingApp.Abstract.DataModel;

namespace SwimmingApp.Abstract.DTO
{
    public class UserDTO : UserModel
    {
        public UserDTO()
        {
            
        }
        public UserDTO(UserModel userModel)
        {
            UserId = userModel?.UserId;
            Name = userModel?.Name;
            Surname = userModel?.Surname;
            Email = userModel?.Email;
            Username = userModel?.Username;
            Password = userModel?.Password;
            Addres = userModel?.Addres;
            UserRoleModel = userModel?.UserRoleModel ?? new UserRoleDTO(userModel?.UserRoleModel);
            ProfileImage = userModel?.ProfileImage;
        }
    }
}

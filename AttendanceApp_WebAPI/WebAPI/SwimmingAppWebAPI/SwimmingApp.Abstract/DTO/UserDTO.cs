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
            ID = userModel?.ID;
            Name = userModel?.Name;
            Surname = userModel?.Surname;
            Email = userModel?.Email;
            Username = userModel?.Username;
            Password = userModel?.Password;
            Address = userModel?.Address;
            UserRoleModel = userModel?.UserRoleModel ?? new UserRoleDTO(userModel?.UserRoleModel);
            ProfileImage = userModel?.ProfileImage;
        }
    }
}

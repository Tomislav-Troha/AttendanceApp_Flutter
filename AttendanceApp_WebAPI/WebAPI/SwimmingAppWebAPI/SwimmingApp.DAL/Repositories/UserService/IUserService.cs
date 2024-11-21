using SwimmingApp.Abstract.DataModel;

namespace SwimmingApp.DAL.Repositories.UserService
{
    public interface IUserService
    {
        Task<IEnumerable<UserModel>?> GetUserByMember();
        Task<UserModel?> GetUserByID(int id);
        Task<UserModel?> InsertUser(UserModel userModel, int? userRole = null);
        Task<UserModel?> GetUserLoginData(string? username);
        Task<UserModel?> GetUserByEmail(string? email);
        Task<UserModel?> GetUserByUsername(string username);
        Task<UserModel?> UpdateUser(UserModel userModel, int id);
        Task<UserModel?> UpdateUserPassword(UserModel userModel);
        Task<IEnumerable<UserModel>?> GetUserByEmployee();
        Task DeleteUser(int id);
        Task<UserRoleModel> SetUserRole(UserRoleModel model, int id);
        Task<IEnumerable<UserModel>?> GetUsersRoleNull();
        Task<IEnumerable<UserRoleModel>?> GetUserRoles();
        Task<UserModel?> SetProfileImage(UserModel model, int id);
        Task<bool> CheckIfFirstEver();
    }
}

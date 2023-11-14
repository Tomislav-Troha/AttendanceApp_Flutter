using SwimmingApp.Abstract.DataModel;
using SwimmingApp.DAL.Repositories.UserService;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SwimmingApp.BL.Managers.UserManager
{
    public class UserManager
    {
        private readonly IUserService _userService;

        public UserManager(IUserService userService)
        {
            _userService = userService; 
        }

        public async Task<IEnumerable<UserRoleModel>> GetUserRoles()
        {
            return await _userService.GetUserRoles();
        }
        public async Task<UserModel> GetUserByID(int id)
        {
            return await _userService.GetUserByID(id);
        }

        public async Task<IEnumerable<UserModel>> GetUserByEmployee()
        {
            return await _userService.GetUserByEmployee();
        }

        public async Task<UserRoleModel> UserSetRole(UserRoleModel model, int id)
        {
            return await _userService.SetUserRole(model, id);
        }

        public async Task<IEnumerable<UserModel>> GetUserRoleNull()
        {
            return await _userService.GetUsersRoleNull();
        }

        public async Task<IEnumerable<UserModel>> GetUserByMember()
        {
            return await _userService.GetUserByMember();
        }

        public async Task DeleteUser(int id)
        {
            await _userService.DeleteUser(id);
        }

        public async Task<UserModel> UpdateUser(int id, UserModel model)
        {
            return await _userService.UpdateUser(model, id);
        }

        public async Task<UserModel> SetProfileImage(UserModel model, int id)
        {
            return await _userService.SetProfileImage(model, id);
        }
    }
}

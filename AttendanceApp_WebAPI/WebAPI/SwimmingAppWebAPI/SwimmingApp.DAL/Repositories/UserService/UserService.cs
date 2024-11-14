using Dapper;
using SwimmingApp.Abstract.DataModel;
using SwimmingApp.DAL.Contex;
using SwimmingApp.DAL.Core;

namespace SwimmingApp.DAL.Repositories.UserService
{
    public class UserService : IUserService
    {
        private readonly IDbService _db;
        private readonly DapperContext _contex;
        public UserService(IDbService dbService, DapperContext context)
        {
            _db = dbService;
            _contex = context;
        }

        public async Task DeleteUser(int id)
        {
            DynamicParameters param = new DynamicParameters();
            param.Add("id", id);

            await _db.DeleteAsync("CALL User_Delete(@id)", param);
        }

        public async Task<IEnumerable<UserRoleModel>?> GetUserRoles()
        {
            return await _db.GetAsync<UserRoleModel>("SELECT * FROM UserRole_Select()");
        }

        public async Task<UserModel?> GetUserByID(int id)
        {
            DynamicParameters param = new DynamicParameters();
            param.Add("id", id);

            var query = "SELECT * FROM User_Select_ByID(@id)";

            using var connection = _contex.CreateConnection();

            IEnumerable<UserModel> users = await connection.QueryAsync<UserModel, UserRoleModel, UserModel>(query,
                (user, userRole) =>
                {
                    user.UserRoleModel = userRole;
                    return user;
                }, param, splitOn: "roleID");

            return users?.FirstOrDefault();
        }

        public async Task<UserModel?> GetUserByEmail(string? email)
        {
            DynamicParameters param = new DynamicParameters();
            param.Add("email", email);

            var query = "SELECT * FROM User_Select_byEmail(@email)";

            using var connection = _contex.CreateConnection();

            IEnumerable<UserModel> users = await connection.QueryAsync<UserModel, UserRoleModel, UserModel>(query,
               (user, userRole) =>
               {
                   user.UserRoleModel = userRole;
                   return user;
               }, param, splitOn: "roleid");

            return users?.FirstOrDefault();
        }

        public async Task<IEnumerable<UserModel>?> GetUserByMember()
        {

            var query = "SELECT * FROM User_Select_ByMember()";

            using var connection = _contex.CreateConnection();

            IEnumerable<UserModel> users = await connection.QueryAsync<UserModel, UserRoleModel, UserModel>(query,
               (user, userRole) =>
               {
                   user.UserRoleModel = userRole;
                   return user;
               }, splitOn: "roleid");

            return users;
        }

        public async Task<IEnumerable<UserModel>?> GetUserByEmployee()
        {
            var query = "SELECT * FROM User_Select_ByEmployee()";

            using var connection = _contex.CreateConnection();

            IEnumerable<UserModel> users = await connection.QueryAsync<UserModel, UserRoleModel, UserModel>(query,
               (user, userRole) =>
               {
                   user.UserRoleModel = userRole;
                   return user;
               }, splitOn: "roleid");

            return users;
        }

        public async Task<UserModel?> GetUserByUsername(string? username)
        {
            DynamicParameters param = new DynamicParameters();
            param.Add("username", username);

            return await _db.FindOneAsync<UserModel>("SELECT * FROM User_Select_ByUsername(@username)", param);
        }

        public async Task<UserModel?> GetUserLoginData(string? email)
        {
            DynamicParameters param = new DynamicParameters();
            param.Add("email", email);

            string query = "SELECT * FROM User_Select_LoginData(@email)";

            using var connection = _contex.CreateConnection();

            IEnumerable<UserModel> users = await connection.QueryAsync<UserModel, UserRoleModel, UserModel>(query,
               (user, userRole) =>
               {
                   user.UserRoleModel = userRole;
                   return user;
               }, param, splitOn: "roleid");

            return users?.FirstOrDefault();
        }

        public async Task<IEnumerable<UserModel>?> GetUsersRoleNull()
        {
            return await _db.GetAsync<UserModel>("SELECT * FROM User_Select_RoleNull()");
        }

        public async Task<UserModel?> InsertUser(UserModel? userModel)
        {
            DynamicParameters param = new DynamicParameters();
            param.Add("name", userModel?.Name);
            param.Add("surname", userModel?.Surname);
            param.Add("email", userModel?.Email);
            param.Add("username", userModel?.Username);
            param.Add("password", userModel?.Password);
            param.Add("salt", userModel?.Salt);
            param.Add("adress", userModel?.Addres);

            await _db.InsertAsync("CALL User_Insert(@name, @surname, @email, @username, @password, @adress, @salt)", param);

            return userModel;
        }

        public async Task<UserRoleModel> SetUserRole(UserRoleModel model, int id)
        {
            DynamicParameters param = new DynamicParameters();
            param.Add("id", id);
            param.Add("userRoleID", model.RoleId);

            await _db.UpdateAsync("CALL User_SetRole(@id, @userRoleID)", param);

            return model;
        }

        public async Task<UserModel?> UpdateUser(UserModel userModel, int id)
        {
            DynamicParameters param = new DynamicParameters();
            param.Add("name", userModel.Name);
            param.Add("surname", userModel.Surname);
            param.Add("adress", userModel.Addres);
            param.Add("id", id);

            await _db.UpdateAsync("CALL User_Update(@id, @name, @surname, @adress)", param);

            return userModel;
        }

        public async Task<UserModel?> SetProfileImage(UserModel model, int id)
        {
            DynamicParameters param = new DynamicParameters();
            param.Add("profileImage", model.ProfileImage);
            param.Add("id", id);

            await _db.UpdateAsync("CALL User_SetProfileImage(@id, @profileImage)", param);

            return model;
        }

        public async Task<UserModel?> UpdateUserPassword(UserModel userModel)
        {
            DynamicParameters param = new DynamicParameters();
            param.Add("email", userModel.Email);
            param.Add("password", userModel.Password);
            param.Add("salt", userModel.Salt);

            await _db.UpdateAsync("CALL User_UpdatePassword(@email, @salt, @password)", param);

            return userModel;
        }
    }
}

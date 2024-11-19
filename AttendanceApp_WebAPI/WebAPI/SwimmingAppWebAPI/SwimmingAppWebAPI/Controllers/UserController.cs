using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using SwimmingApp.Abstract.DataModel;
using SwimmingApp.DAL.Logger;
using SwimmingApp.DAL.Repositories.UserService;

namespace SwimmingAppWebAPI.Controllers
{
    [Route("user")]
    [ApiController]
    public class UserController : Controller
    {
        private readonly IUserService _userService;
        public UserController(IUserService userManager)
        {
            _userService = userManager;
        }

        [Authorize]
        [HttpGet]
        [Route("getUserByMember")]
        public async Task<IActionResult> GetUserByMember()
        {
            try
            {
                var result = await _userService.GetUserByMember();
                return Ok(result);
            }
            catch (Exception e)
            {
                await GlobalLogger.LogError(e);
                return StatusCode(500, new { Error = "Internal Server Error" });
            }
        }

        [Authorize]
        [HttpGet]
        [Route("getUserByEmployee")]
        public async Task<IActionResult> GetUserByEmployee()
        {
            try
            {
                var result = await _userService.GetUserByEmployee();
                return Ok(result);
            }
            catch (Exception e)
            {
                await GlobalLogger.LogError(e);
                return StatusCode(500, new { Error = "Internal Server Error" });
            }
        }

        [Authorize]
        [HttpGet]
        [Route("getUserByID/{id}")]
        public async Task<IActionResult> GetUserByID(int id)
        {
            try
            {
                var result = await _userService.GetUserByID(id);
                return Ok(result);
            }
            catch (Exception e)
            {
                await GlobalLogger.LogError(e);
                return StatusCode(500, new { Error = "Internal Server Error" });
            }
        }

        [Authorize]
        [HttpPut]
        [Route("setUserRole/{id}")]
        public async Task<IActionResult> SetUserRole(UserRoleModel model, int id)
        {
            try
            {
                var result = await _userService.SetUserRole(model, id);
                return Ok(result);
            }
            catch (Exception e)
            {
                await GlobalLogger.LogError(e);
                return StatusCode(500, new { Error = "Internal Server Error" });
            }
        }

        [Authorize]
        [HttpGet("userRoleIsNull")]
        public async Task<IActionResult> GetUserRoleNull()
        {
            try
            {
                var result = await _userService.GetUsersRoleNull();
                return Ok(result);
            }
            catch (Exception e)
            {
                await GlobalLogger.LogError(e);
                return StatusCode(500, new { Error = "Internal Server Error" });
            }
        }

        [Authorize]
        [HttpGet("getUserRoles")]
        public async Task<IActionResult> GetUserRoles()
        {
            try
            {
                var result = await _userService.GetUserRoles();
                return Ok(result);
            }
            catch (Exception e)
            {
                await GlobalLogger.LogError(e);
                return StatusCode(500, new { Error = "Internal Server Error" });
            }
        }

        [Authorize]
        [HttpDelete]
        [Route("deleteUser/{id}")]
        public async Task<IActionResult> DeleteUser(int id)
        {
            try
            {
                await _userService.DeleteUser(id);
                return Ok();
            }
            catch (Exception e)
            {
                await GlobalLogger.LogError(e);
                return StatusCode(500, new { Error = "Internal Server Error" });
            }
        }

        [Authorize]
        [HttpPut]
        [Route("updateUser/{id}")]
        public async Task<IActionResult> UpdateUser(UserModel model, int id)
        {
            try
            {
                var result = await _userService.UpdateUser(model, id);
                return Ok(result);
            }
            catch (Exception e)
            {
                await GlobalLogger.LogError(e);
                return StatusCode(500, new { Error = "Internal Server Error" });
            }
        }

        [Authorize]
        [HttpPut]
        [Route("setProfileImage/{id}")]
        public async Task<IActionResult> SetProfileImage(UserModel model, int id)
        {
            try
            {
                var result = await _userService.SetProfileImage(model, id);
                return Ok(result);
            }
            catch (Exception e)
            {
                await GlobalLogger.LogError(e);
                return StatusCode(500, new { Error = "Internal Server Error" });
            }
        }
    }
}

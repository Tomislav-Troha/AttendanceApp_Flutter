using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using SwimmingApp.Abstract.DataModel;
using SwimmingApp.BL.Managers.Log;
using SwimmingApp.BL.Managers.UserManager;

namespace SwimmingAppWebAPI.Controllers
{
    [Route("user")]
    [ApiController]
    public class UserController : Controller
    {
        private readonly UserManager _userManager;
        private readonly ErrorLogsManager _errorLogsManager;
        public UserController(UserManager userManager, ErrorLogsManager errorLogsManager)
        {
            _userManager = userManager;
            _errorLogsManager = errorLogsManager;
        }

        [Authorize]
        [HttpGet]
        [Route("getUserByMember")]
        public async Task<IActionResult> GetUserByMember()
        {
            try
            {
                var result = await _userManager.GetUserByMember();
                return Ok(result);
            }
            catch (Exception e)
            {
                await _errorLogsManager.LogError(e);
                return BadRequest(e);
            }
        }

        [Authorize]
        [HttpGet]
        [Route("getUserByEmployee")]
        public async Task<IActionResult> GetUserByEmployee()
        {
            try
            {
                var result = await _userManager.GetUserByEmployee();
                return Ok(result);
            }
            catch (Exception e)
            {
                await _errorLogsManager.LogError(e);
                return BadRequest(e);
            }
        }

        [Authorize]
        [HttpGet]
        [Route("getUserByID/{id}")]
        public async Task<IActionResult> GetUserByID(int id)
        {
            try
            {
                var result = await _userManager.GetUserByID(id);
                return Ok(result);
            }
            catch (Exception e)
            {
                await _errorLogsManager.LogError(e);
                return BadRequest(e);
            }
        }

        [Authorize]
        [HttpPut]
        [Route("setUserRole/{id}")]
        public async Task<IActionResult> SetUserRole(UserRoleModel model, int id)
        {
            try
            {
                var result = await _userManager.UserSetRole(model, id);
                return Ok(result);
            }
            catch (Exception e)
            {
                await _errorLogsManager.LogError(e);
                return BadRequest(e);
            }
        }

        [Authorize]
        [HttpGet("userRoleIsNull")]
        public async Task<IActionResult> GetUserRoleNull()
        {
            try
            {
                var result = await _userManager.GetUserRoleNull();
                return Ok(result);
            }
            catch (Exception e)
            {
                await _errorLogsManager.LogError(e);
                return BadRequest(e);
            }
        }

        [Authorize]
        [HttpGet("getUserRoles")]
        public async Task<IActionResult> GetUserRoles()
        {
            try
            {
                var result = await _userManager.GetUserRoles();
                return Ok(result);
            }
            catch (Exception e)
            {
                await _errorLogsManager.LogError(e);
                return BadRequest(e);
            }
        }

        [Authorize]
        [HttpDelete]
        [Route("deleteUser/{id}")]
        public async Task<IActionResult> DeleteUser(int id)
        {
            try
            {
                await _userManager.DeleteUser(id);
                return Ok();
            }
            catch (Exception e)
            {
                await _errorLogsManager.LogError(e);
                return BadRequest(e);
            }
        }

        [Authorize]
        [HttpPut]
        [Route("updateUser/{id}")]
        public async Task<IActionResult> UpdateUser(UserModel model, int id)
        {
            try
            {
                var result = await _userManager.UpdateUser(id, model);
                return Ok(result);
            }
            catch (Exception e)
            {
                await _errorLogsManager.LogError(e);
                return BadRequest(e.Message);
            }
        }

        [Authorize]
        [HttpPut]
        [Route("setProfileImage/{id}")]
        public async Task<IActionResult> SetProfileImage(UserModel model, int id)
        {
            try
            {
                var result = await _userManager.SetProfileImage(model, id);
                return Ok(result);
            }
            catch (Exception e)
            {
                await _errorLogsManager.LogError(e);
                return BadRequest(e);
            }
        }



    }
}

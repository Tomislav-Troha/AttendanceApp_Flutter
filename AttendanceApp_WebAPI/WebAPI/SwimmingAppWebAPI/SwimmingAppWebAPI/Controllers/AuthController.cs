using Microsoft.AspNetCore.Mvc;
using SwimmingApp.Abstract.DTO;
using SwimmingApp.BL.Managers.Log;
using SwimmingApp.BL.Managers.UserLoginManager;
using SwimmingApp.BL.Managers.UserRegisterManager;

namespace SwimmingAppWebAPI.Controllers
{
    [Route("auth")]
    [ApiController]
    public class AuthController : Controller
    {

        private readonly UserRegisterManager _userRegisterManager;
        private readonly UserLoginManager _userLoginManager;
        private readonly ErrorLogsManager _errorLogsManager;
        public AuthController(UserRegisterManager userRegisterManager, UserLoginManager userLoginManager, ErrorLogsManager errorLogsManager)
        {
            _userRegisterManager = userRegisterManager;
            _userLoginManager = userLoginManager;
            _errorLogsManager = errorLogsManager;
        }


        [HttpPost]
        [Route("register")]
        public async Task<IActionResult> Register(UserRegisterDTO userRegisterDTO)
        {
            try
            {
                //var adminId = HttpContext?.User.Claims.Where(x => x.Type == "UserId").Single();
                var response = await _userRegisterManager.UserRegister(userRegisterDTO, 1);
                return Ok(response);
            }
            catch (Exception e)
            {
                await _errorLogsManager.LogError(e);
                return BadRequest(e);
            }
        }

        [HttpPost]
        [Route("login")]
        public async Task<IActionResult> Login(UserLoginDTO login)
        {
            try
            {
                var response = await _userLoginManager.LoginUser(login);
                return Ok(response);
            }
            catch (Exception e)
            {
                await _errorLogsManager.LogError(e);
                return BadRequest(e);
            }
        }


    }
}

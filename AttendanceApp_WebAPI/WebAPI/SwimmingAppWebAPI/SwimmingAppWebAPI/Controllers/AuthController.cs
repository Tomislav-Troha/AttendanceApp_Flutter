using Microsoft.AspNetCore.Mvc;
using SwimmingApp.Abstract.DTO;
using SwimmingApp.DAL.Repositories.Log;
using SwimmingApp.DAL.Repositories.UserLoginService;
using SwimmingApp.DAL.Repositories.UserRegisterService;

namespace SwimmingAppWebAPI.Controllers
{
    [Route("auth")]
    [ApiController]
    public class AuthController : Controller
    {

        private readonly UserRegisterService _userRegisterService;
        private readonly UserLoginService _userLoginService;
        private readonly ErrorLogService _errorLogsService;
        public AuthController(UserRegisterService userRegisterService, UserLoginService userLoginService, ErrorLogService errorLogsService)
        {
            _userRegisterService = userRegisterService;
            _errorLogsService = errorLogsService;
            _userLoginService = userLoginService;
        }


        [HttpPost]
        [Route("register")]
        public async Task<IActionResult> Register(UserRegisterDTO userRegisterDTO)
        {
            try
            {
                //var adminId = HttpContext?.User.Claims.Where(x => x.Type == "UserId").Single();
                var response = await _userRegisterService.UserRegister(userRegisterDTO, 1);
                return Ok(response);
            }
            catch (Exception e)
            {
                await _errorLogsService.LogError(e);
                return BadRequest(e);
            }
        }

        [HttpPost]
        [Route("login")]
        public async Task<IActionResult> Login(UserLoginDTO login)
        {
            try
            {
                var response = await _userLoginService.UserLogin(login);
                return Ok(response);
            }
            catch (Exception e)
            {
                await _errorLogsService.LogError(e);
                return BadRequest(e);
            }
        }


    }
}

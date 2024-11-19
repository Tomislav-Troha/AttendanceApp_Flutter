using Microsoft.AspNetCore.Mvc;
using SwimmingApp.Abstract.DTO;
using SwimmingApp.DAL.Logger;
using SwimmingApp.DAL.Repositories.UserLoginService;
using SwimmingApp.DAL.Repositories.UserRegisterService;

namespace SwimmingAppWebAPI.Controllers
{
    [Route("auth")]
    [ApiController]
    public class AuthController : Controller
    {

        private readonly IUserRegisterService _userRegisterService;
        private readonly IUserLoginService _userLoginService;
        public AuthController(IUserRegisterService userRegisterService, IUserLoginService userLoginService)
        {
            _userRegisterService = userRegisterService;
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
                await GlobalLogger.LogError(e);
                return StatusCode(500, new { Error = "Internal Server Error" });
            }
        }

        [HttpPost]
        [Route("login")]
        public async Task<IActionResult> Login([FromQuery] UserLoginDTO login)
        {
            try
            {
                var response = await _userLoginService.UserLogin(login);
                return Ok(response);
            }
            catch (Exception e)
            {
                await GlobalLogger.LogError(e);
                return StatusCode(500, new { Error = "Internal Server Error" });
            }
        }
    }
}

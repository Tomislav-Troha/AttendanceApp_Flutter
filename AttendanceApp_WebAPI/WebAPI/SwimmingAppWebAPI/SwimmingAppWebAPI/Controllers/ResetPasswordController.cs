using Microsoft.AspNetCore.Mvc;
using SwimmingApp.Abstract.DTO;
using SwimmingApp.DAL.Logger;
using SwimmingApp.DAL.Repositories.PaswordResetService;

namespace SwimmingAppWebAPI.Controllers
{
    [Route("passwordReset")]
    [ApiController]
    public class ResetPasswordController : Controller
    {
        private readonly IPasswordResetService _changePasswordService;

        public ResetPasswordController(IPasswordResetService changePasswordManager)
        {
            _changePasswordService = changePasswordManager;
        }

        [HttpPut]
        [Route("resetPassword")]
        public async Task<IActionResult> ResetPassword(PasswordResetDTO model)
        {
            try
            {
                var result = await _changePasswordService.PasswordReset(model);
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

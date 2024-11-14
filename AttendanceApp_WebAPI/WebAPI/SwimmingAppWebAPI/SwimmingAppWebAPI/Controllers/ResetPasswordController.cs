using Microsoft.AspNetCore.Mvc;
using SwimmingApp.Abstract.DTO;
using SwimmingApp.DAL.Repositories.Log;
using SwimmingApp.DAL.Repositories.PaswordResetService;

namespace SwimmingAppWebAPI.Controllers
{
    [Route("passwordReset")]
    [ApiController]
    public class ResetPasswordController : Controller
    {
        private readonly PasswordResetService _changePasswordService;
        private readonly ErrorLogService _errorLogsService;

        public ResetPasswordController(PasswordResetService changePasswordManager, ErrorLogService errorLogsManager)
        {
            _changePasswordService = changePasswordManager;
            _errorLogsService = errorLogsManager;
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
                await _errorLogsService.LogError(e);
                return BadRequest(e);
            }
        }

    }
}

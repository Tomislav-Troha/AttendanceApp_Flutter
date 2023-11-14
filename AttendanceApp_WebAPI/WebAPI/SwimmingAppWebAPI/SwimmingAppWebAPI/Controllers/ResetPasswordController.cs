using Microsoft.AspNetCore.Mvc;
using SwimmingApp.Abstract.DTO;
using SwimmingApp.BL.Managers.ChangePasswordManager;
using SwimmingApp.BL.Managers.Log;

namespace SwimmingAppWebAPI.Controllers
{
    [Route("passwordReset")]
    [ApiController]
    public class ResetPasswordController : Controller
    {
        private readonly PasswordResetManager _changePasswordManager;
        private readonly ErrorLogsManager _errorLogsManager;

        public ResetPasswordController(PasswordResetManager changePasswordManager, ErrorLogsManager errorLogsManager)
        {
            _changePasswordManager = changePasswordManager;
            _errorLogsManager = errorLogsManager;
        }


        [HttpPut]
        [Route("resetPassword")]
        public async Task<IActionResult> ResetPassword(PasswordResetDTO model)
        {
            try
            {
                var result = await _changePasswordManager.ResetPassword(model);
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

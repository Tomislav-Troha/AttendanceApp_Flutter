using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using SwimmingApp.Abstract.DTO;
using SwimmingApp.DAL.Logger;
using SwimmingApp.DAL.Repositories.AttendanceService;

namespace SwimmingAppWebAPI.Controllers
{
    [Route("attendance")]
    [ApiController]
    public class AttendanceController : Controller
    {
        private readonly IAttendanceService _attendanceService;
        public AttendanceController(IAttendanceService attendanceService)
        {
            _attendanceService = attendanceService;
        }

        [Authorize]
        [HttpPost]
        [Route("addAttendance")]
        public async Task<IActionResult> InsertAttendance(AttendanceDTO attendanceDTO)
        {
            try
            {
                if (!int.TryParse(HttpContext?.User?.Claims?.FirstOrDefault(x => x.Type == "UserID")?.Value, out int userId))
                    return BadRequest("User not found.");

                var result = await _attendanceService.InsertAttendance(attendanceDTO, userId);
                return Ok(result);
            }
            catch (Exception e)
            {
                await GlobalLogger.LogError(e);
                return StatusCode(500, new { Error = "Internal Server Error" });
            }
        }

        [Authorize]
        [HttpPost]
        [Route("addAttendanceNotSubmitted")]
        public async Task<IActionResult> InsertAttendanceNotSubmitted(AttendanceDTO attendanceDTO)
        {
            try
            {
                var result = await _attendanceService.InsertAttendanceNotSubmitted(attendanceDTO, attendanceDTO?.UserModel?.ID);
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
        [Route("getAttendance")]
        public async Task<IActionResult> GetAttendanceByUser()
        {
            try
            {
                if (!int.TryParse(HttpContext?.User?.Claims?.FirstOrDefault(x => x.Type == "UserID")?.Value, out int userId))
                    return BadRequest("User not found.");

                var response = await _attendanceService.GetAttendanceByUserID(userId);
                return Ok(response);
            }
            catch (Exception e)
            {
                await GlobalLogger.LogError(e);
                return StatusCode(500, new { Error = "Internal Server Error" });
            }
        }

        [Authorize]
        [HttpDelete]
        [Route("deleteAttendance")]
        public async Task<IActionResult> DeleteAttendance(int id)
        {
            try
            {
                await _attendanceService.DeleteAttendance(id);
                return Ok();
            }
            catch (Exception e)
            {
                await GlobalLogger.LogError(e);
                return StatusCode(500, new { Error = "Internal Server Error" });
            }
        }

        [Authorize]
        [HttpGet]
        [Route("getAttendanceAll/{userID?}")]
        public async Task<IActionResult> GetAttendanceAll(int? userID = null)
        {
            try
            {
                var result = await _attendanceService.GetAttendanceAll(userID);
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

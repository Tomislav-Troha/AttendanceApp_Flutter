using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using SwimmingApp.Abstract.DTO;
using SwimmingApp.DAL.Repositories.AttendanceService;
using SwimmingApp.DAL.Repositories.Log;

namespace SwimmingAppWebAPI.Controllers
{
    [Route("attendance")]
    [ApiController]
    public class AttendanceController : Controller
    {
        private readonly AttendanceService _attendanceService;
        private readonly ErrorLogService _errorLogsService;
        public AttendanceController(AttendanceService attendanceService, ErrorLogService errorLogsService)
        {
            _attendanceService = attendanceService;
            _errorLogsService = errorLogsService;
        }


        [Authorize]
        [HttpPost]
        [Route("addAttendance")]
        public async Task<IActionResult> InsertAttendance(AttendanceDTO attendanceDTO)
        {
            try
            {
                var userId = HttpContext?.User.Claims.FirstOrDefault(x => x.Type == "UserID");
                if (userId == null)
                    return BadRequest("User not found.");

                var result = await _attendanceService.InsertAttendance(attendanceDTO, int.Parse(userId.Value));
                return Ok(result);
            }
            catch (Exception e)
            {
                await _errorLogsService.LogError(e);
                return BadRequest(e);
            }
        }

        [Authorize]
        [HttpPost]
        [Route("addAttendanceNotSubmitted")]
        public async Task<IActionResult> InsertAttendanceNotSubmitted(AttendanceDTO attendanceDTO)
        {
            try
            {
                var result = await _attendanceService.InsertAttendanceNotSubmitted(attendanceDTO, attendanceDTO?.UserModel?.UserId);
                return Ok(result);
            }
            catch (Exception e)
            {
                await _errorLogsService.LogError(e);
                return BadRequest(e);
            }
        }

        [Authorize]
        [HttpGet]
        [Route("getAttendance")]
        public async Task<IActionResult> GetAttendanceByUser()
        {
            try
            {
                var userId = HttpContext?.User.Claims.FirstOrDefault(x => x.Type == "UserID");
                if (userId == null)
                    return BadRequest("User not found.");
                var response = await _attendanceService.GetAttendanceByUserID(int.Parse(userId.Value));
                return Ok(response);
            }
            catch (Exception e)
            {
                await _errorLogsService.LogError(e);
                return BadRequest(e);
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
                await _errorLogsService.LogError(e);
                return BadRequest(e);
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
                await _errorLogsService.LogError(e);
                return BadRequest(e);
            }
        }

    }
}

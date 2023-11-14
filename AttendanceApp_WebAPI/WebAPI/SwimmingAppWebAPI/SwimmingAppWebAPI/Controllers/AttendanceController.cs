using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using SwimmingApp.Abstract.DTO;
using SwimmingApp.BL.Managers.AttendanceManager;
using SwimmingApp.BL.Managers.Log;

namespace SwimmingAppWebAPI.Controllers
{
    [Route("attendance")]
    [ApiController]
    public class AttendanceController : Controller
    {
        private readonly AttendanceManager _attendanceManager;
        private readonly ErrorLogsManager _errorLogsManager;
        public AttendanceController(AttendanceManager attendanceManager, ErrorLogsManager errorLogsManager)
        {
            _attendanceManager = attendanceManager;
            _errorLogsManager = errorLogsManager;
        }


        [Authorize]
        [HttpPost]
        [Route("addAttendance")]
        public async Task<IActionResult> InsertAttendance(AttendanceDTO attendanceDTO)
        {
            try
            {
                var userId = HttpContext?.User.Claims.Where(x => x.Type == "UserID").Single();
                //var userRoleId = HttpContext?.User.Claims.Where(x => x.Type == "UserRoleId").Single();
                var result = await _attendanceManager.InsertAttendance(attendanceDTO, int.Parse(userId.Value));
                return Ok(result);
            }
            catch (Exception e)
            {
                await _errorLogsManager.LogError(e);
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
                var result = await _attendanceManager.InsertAttendanceNotSubmitted(attendanceDTO, attendanceDTO.UserModel.UserId);
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
        [Route("getAttendance")]
        public async Task<IActionResult> GetAttendanceByUser()
        {
            try
            {
                var userId = HttpContext?.User.Claims.Where(x => x.Type == "UserID").Single();
                var response = await _attendanceManager.GetAttendanceByUser(int.Parse(userId.Value));
                return Ok(response);
            }
            catch (Exception e)
            {
                await _errorLogsManager.LogError(e);
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
                await _attendanceManager.DeleteAttendance(id);
                return Ok();
            }
            catch (Exception e)
            {
                await _errorLogsManager.LogError(e);
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
                var result = await _attendanceManager.GetAttendanceAll(userID);
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

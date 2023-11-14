using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using SwimmingApp.Abstract.DataModel;
using SwimmingApp.BL.Managers.JobRoleManager;
using SwimmingApp.BL.Managers.Log;

namespace SwimmingAppWebAPI.Controllers
{
    [ApiController]
    [Route("jobRole")]
    public class JobRoleController : Controller
    {
        private readonly JobRoleManager _jobRoleManager;
        private readonly ErrorLogsManager _errorLogsManager;
       
        public JobRoleController(JobRoleManager jobRoleManager, ErrorLogsManager errorLogsManager)
        {
            _jobRoleManager = jobRoleManager;
            _errorLogsManager = errorLogsManager;
        }

        [HttpGet, Route("getJobRoles")]
        public async Task<IActionResult> GetJobRoles()
        {
            try
            {
                var response = await _jobRoleManager.GetJobRoles();
                return Ok(response);
            }
            catch (Exception e)
            {
                await _errorLogsManager.LogError(e);
                return BadRequest(e.Message);
            }
        }

        [HttpPost, Route("insertJobRole")]
        public async Task<IActionResult> InsertJobRole(JobRoleModel model)
        {
            try
            {
                var response = await _jobRoleManager.InsertJobRole(model);
                return Ok(response);
            }
            catch (Exception e)
            {
                await _errorLogsManager.LogError(e);
                return BadRequest(e.Message);
            }
        }
    }
}

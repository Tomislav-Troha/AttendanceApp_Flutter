using Microsoft.AspNetCore.Mvc;
using SwimmingApp.Abstract.DataModel;
using SwimmingApp.DAL.Repositories.JobRoleService;
using SwimmingApp.DAL.Repositories.Log;

namespace SwimmingAppWebAPI.Controllers
{
    [ApiController]
    [Route("jobRole")]
    public class JobRoleController : Controller
    {
        private readonly JobRoleService _jobRoleService;
        private readonly ErrorLogService _errorLogsService;

        public JobRoleController(JobRoleService jobRoleManager, ErrorLogService errorLogsManager)
        {
            _jobRoleService = jobRoleManager;
            _errorLogsService = errorLogsManager;
        }

        [HttpGet, Route("getJobRoles")]
        public async Task<IActionResult> GetJobRoles()
        {
            try
            {
                var response = await _jobRoleService.GetJobRoles();
                return Ok(response);
            }
            catch (Exception e)
            {
                await _errorLogsService.LogError(e);
                return BadRequest(e.Message);
            }
        }

        [HttpPost, Route("insertJobRole")]
        public async Task<IActionResult> InsertJobRole(JobRoleModel model)
        {
            try
            {
                var response = await _jobRoleService.InsertJobRole(model);
                return Ok(response);
            }
            catch (Exception e)
            {
                await _errorLogsService.LogError(e);
                return BadRequest(e.Message);
            }
        }
    }
}

using Microsoft.AspNetCore.Mvc;
using SwimmingApp.Abstract.DataModel;
using SwimmingApp.DAL.Logger;
using SwimmingApp.DAL.Repositories.JobRoleService;

namespace SwimmingAppWebAPI.Controllers
{
    [ApiController]
    [Route("jobRole")]
    public class JobRoleController : Controller
    {
        private readonly IJobRoleService _jobRoleService;

        public JobRoleController(IJobRoleService jobRoleManager)
        {
            _jobRoleService = jobRoleManager;
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
                await GlobalLogger.LogError(e);
                return StatusCode(500, new { Error = "Internal Server Error" });
            }
        }

        [HttpPost, Route("insertJobRole")]
        public async Task<IActionResult> InsertJobRole([FromQuery]JobRoleModel model)
        {
            try
            {
                var response = await _jobRoleService.InsertJobRole(model);
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

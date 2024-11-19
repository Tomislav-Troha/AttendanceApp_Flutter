using Microsoft.AspNetCore.Mvc;
using SwimmingApp.Abstract.DataModel;
using SwimmingApp.DAL.Logger;
using SwimmingApp.DAL.Repositories.SalaryPackageTypeService;

namespace SwimmingAppWebAPI.Controllers
{
    [ApiController]
    [Route("salaryPackageType")]
    public class SalaryPackageTypeController : Controller
    {
        private readonly ISalaryPackageTypeService _salaryPackageTypeService;

        public SalaryPackageTypeController(ISalaryPackageTypeService salaryPackageTypeManager)
        {
            _salaryPackageTypeService = salaryPackageTypeManager;
        }

        [HttpGet, Route("getSalaryPackageType")]
        public async Task<IActionResult> GetSalaryPackageType()
        {
            try
            {
                var response = await _salaryPackageTypeService.GetSalaryPackageTypes();
                return Ok(response);
            }
            catch (Exception e)
            {
                await GlobalLogger.LogError(e);
                return StatusCode(500, new { Error = "Internal Server Error" });
            }
        }

        [HttpPost, Route("insertSalaryPackageType")]
        public async Task<IActionResult> InsertSalaryPackageType(SalaryPackageTypeModel model)
        {
            try
            {
                var response = await _salaryPackageTypeService.InsertSalaryPackageType(model);
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

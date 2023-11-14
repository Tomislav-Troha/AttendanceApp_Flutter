using Microsoft.AspNetCore.Mvc;
using SwimmingApp.Abstract.DataModel;
using SwimmingApp.BL.Managers.SalaryPackageTypeManager;

namespace SwimmingAppWebAPI.Controllers
{
    [ApiController]
    [Route("salaryPackageType")]
    public class SalaryPackageTypeController : Controller
    {
        private readonly SalaryPackageTypeManager _salaryPackageTypeManager;

        public SalaryPackageTypeController(SalaryPackageTypeManager salaryPackageTypeManager)
        {
            _salaryPackageTypeManager = salaryPackageTypeManager;
        }

        [HttpGet, Route("getSalaryPackageType")]
        public async Task<IActionResult> GetSalaryPackageType()
        {
            try
            {
                var response = await _salaryPackageTypeManager.GetSalaryPackageTypes();
                return Ok(response);
            }
            catch (Exception e)
            {
                return BadRequest(e.Message);
            }
        }

        [HttpPost, Route("insertSalaryPackageType")]
        public async Task<IActionResult> InsertSalaryPackageType(SalaryPackageTypeModel model)
        {
            try
            {
                var response = await _salaryPackageTypeManager.InsertSalaryPackageType(model);
                return Ok(response);
            }
            catch (Exception e)
            {
                return BadRequest(e.Message);
            }
        }
    }
}

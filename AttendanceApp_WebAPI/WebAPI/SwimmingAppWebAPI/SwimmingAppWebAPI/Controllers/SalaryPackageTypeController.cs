using Microsoft.AspNetCore.Mvc;
using SwimmingApp.Abstract.DataModel;
using SwimmingApp.DAL.Repositories.SalaryPackageTypeService;

namespace SwimmingAppWebAPI.Controllers
{
    [ApiController]
    [Route("salaryPackageType")]
    public class SalaryPackageTypeController : Controller
    {
        private readonly SalaryPackageTypeService _salaryPackageTypeService;

        public SalaryPackageTypeController(SalaryPackageTypeService salaryPackageTypeManager)
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
                return BadRequest(e.Message);
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
                return BadRequest(e.Message);
            }
        }
    }
}

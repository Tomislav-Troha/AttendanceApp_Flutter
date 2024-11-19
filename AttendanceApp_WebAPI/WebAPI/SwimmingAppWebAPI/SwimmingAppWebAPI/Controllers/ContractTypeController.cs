using Microsoft.AspNetCore.Mvc;
using SwimmingApp.Abstract.DataModel;
using SwimmingApp.DAL.Logger;
using SwimmingApp.DAL.Repositories.ContractTypeService;

namespace SwimmingAppWebAPI.Controllers
{
    [ApiController]
    [Route("contractType")]
    public class ContractTypeController : Controller
    {
        private readonly IContractTypeService _contractTypeService;
        public ContractTypeController(IContractTypeService contractTypeManager)
        {
            _contractTypeService = contractTypeManager;
        }

        [HttpGet, Route("getContractTypes")]
        public async Task<IActionResult> GetContractTypes()
        {
            try
            {
                var response = await _contractTypeService.GetContractTypes();
                return Ok(response);
            }
            catch (Exception e)
            {
                await GlobalLogger.LogError(e);
                return StatusCode(500, new { Error = "Internal Server Error" });
            }
        }

        [HttpPost, Route("insertContractType")]
        public async Task<IActionResult> InsertContractType(ContractTypeModel model)
        {
            try
            {
                var response = await _contractTypeService.InsertContractType(model);
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

using Microsoft.AspNetCore.Mvc;
using SwimmingApp.Abstract.DataModel;
using SwimmingApp.DAL.Repositories.ContractTypeService;
using SwimmingApp.DAL.Repositories.Log;

namespace SwimmingAppWebAPI.Controllers
{
    [ApiController]
    [Route("contractType")]
    public class ContractTypeController : Controller
    {
        private readonly ContractTypeService _contractTypeService;
        private readonly ErrorLogService _errorLogsService;

        public ContractTypeController(ContractTypeService contractTypeManager, ErrorLogService errorLogsManager)
        {
            _contractTypeService = contractTypeManager;
            _errorLogsService = errorLogsManager;
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
                await _errorLogsService.LogError(e);
                return BadRequest(e.Message);
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
                await _errorLogsService.LogError(e);
                return BadRequest(e.Message);
            }
        }
    }
}

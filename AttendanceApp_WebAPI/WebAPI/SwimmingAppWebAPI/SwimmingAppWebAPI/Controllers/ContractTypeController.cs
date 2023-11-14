using Microsoft.AspNetCore.Mvc;
using SwimmingApp.Abstract.DataModel;
using SwimmingApp.BL.Managers.ContractTypeManager;
using SwimmingApp.BL.Managers.Log;

namespace SwimmingAppWebAPI.Controllers
{
    [ApiController]
    [Route("contractType")]
    public class ContractTypeController : Controller
    {
        private readonly ContractTypeManager _contractTypeManager;
        private readonly ErrorLogsManager _errorLogsManager;

        public ContractTypeController(ContractTypeManager contractTypeManager, ErrorLogsManager errorLogsManager)
        {
            _contractTypeManager = contractTypeManager;
            _errorLogsManager = errorLogsManager;
        }

        [HttpGet, Route("getContractTypes")]
        public async Task<IActionResult> GetContractTypes()
        {
            try
            {
                var response = await _contractTypeManager.GetContractTypes();
                return Ok(response);
            }
            catch (Exception e)
            {
                await _errorLogsManager.LogError(e);
                return BadRequest(e.Message);
            }
        }

        [HttpPost, Route("insertContractType")]
        public async Task<IActionResult> InsertContractType(ContractTypeModel model)
        {
            try
            {
                var response = await _contractTypeManager.InsertContractType(model);
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

using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using SwimmingApp.Abstract.DTO;
using SwimmingApp.DAL.Repositories.EmployeeContract;
using SwimmingApp.DAL.Repositories.Log;

namespace SwimmingAppWebAPI.Controllers
{
    [Route("contract")]
    [ApiController]
    public class ContractController : Controller
    {
        private readonly ContractService _contractService;
        private readonly ErrorLogService _errorLogsService;
        public ContractController(ContractService contractService, ErrorLogService errorLogsService)
        {
            _contractService = contractService;
            _errorLogsService = errorLogsService;
        }

        [Authorize]
        [HttpPost]
        [Route("addContract/{userId}")]
        public async Task<IActionResult> InsertContract(ContractDTO employeeContractDTO, int userId)
        {
            try
            {
                var result = await _contractService.InsertContract(employeeContractDTO, userId);
                return Ok(result);
            }
            catch (Exception e)
            {
                await _errorLogsService.LogError(e);
                return BadRequest(e);
            }
        }

        [Authorize]
        [HttpGet, Route("getContract/{userID?}")]
        public async Task<IActionResult> GetContract(int? userID = null)
        {
            try
            {
                var result = await _contractService.GetContracts(userID);
                return Ok(result);
            }
            catch (Exception e)
            {
                await _errorLogsService.LogError(e);
                return BadRequest(e);
            }
        }

        [Authorize]
        [HttpPut, Route("updateContract")]
        public async Task<IActionResult> UpdateContract(ContractDTO model)
        {
            try
            {
                var result = await _contractService.UpdateContract(model);
                return Ok(result);
            }
            catch (Exception e)
            {
                await _errorLogsService.LogError(e);
                return BadRequest(e);
            }
        }


    }
}

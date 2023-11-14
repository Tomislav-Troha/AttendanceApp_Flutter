using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using SwimmingApp.Abstract.Data;
using SwimmingApp.Abstract.DTO;
using SwimmingApp.BL.Managers.AttendanceManager;
using SwimmingApp.BL.Managers.EmployeeContractManager;
using SwimmingApp.BL.Managers.Log;

namespace SwimmingAppWebAPI.Controllers
{
    [Route("contract")]
    [ApiController]
    public class ContractController : Controller
    {
        private readonly ContractManager _contractManager;
        private readonly ErrorLogsManager _errorLogsManager;
        public ContractController(ContractManager contractManager, ErrorLogsManager errorLogsManager)
        {
            _contractManager = contractManager;
            _errorLogsManager = errorLogsManager;
        }

        [Authorize]
        [HttpPost]
        [Route("addContract/{userId}")]
        public async Task<IActionResult> InsertContract(ContractDTO employeeContractDTO, int userId)
        {
            try
            {
                var result = await _contractManager.InsertContract(employeeContractDTO, userId);
                return Ok(result);
            }
            catch (Exception e)
            {
                await _errorLogsManager.LogError(e);
                return BadRequest(e);
            }
        }

        [Authorize]
        [HttpGet, Route("getContract/{userID?}")]
        public async Task<IActionResult> GetContract(int? userID = null)
        {
            try
            {
                var result = await _contractManager.GetContract(userID);
                return Ok(result);
            }
            catch (Exception e)
            {
                await _errorLogsManager.LogError(e);
                return BadRequest(e);
            }
        }

        [Authorize]
        [HttpPut, Route("updateContract")]
        public async Task<IActionResult> UpdateContract(ContractDTO model)
        {
            try
            {
                var result = await _contractManager.UpdateContract(model);
                return Ok(result);
            }
            catch (Exception e)
            {
                await _errorLogsManager.LogError(e);
                return BadRequest(e);
            }
        }


    }
}

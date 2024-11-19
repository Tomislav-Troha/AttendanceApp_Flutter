using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using SwimmingApp.Abstract.DTO;
using SwimmingApp.DAL.Logger;
using SwimmingApp.DAL.Repositories.EmployeeContract;

namespace SwimmingAppWebAPI.Controllers
{
    [Route("contract")]
    [ApiController]
    public class ContractController : Controller
    {
        private readonly IContractService _contractService;
        public ContractController(IContractService contractService)
        {
            _contractService = contractService;
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
                await GlobalLogger.LogError(e);
                return StatusCode(500, new { Error = "Internal Server Error" });
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
                await GlobalLogger.LogError(e);
                return StatusCode(500, new { Error = "Internal Server Error" });
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
                await GlobalLogger.LogError(e);
                return StatusCode(500, new { Error = "Internal Server Error" });
            }
        }


    }
}

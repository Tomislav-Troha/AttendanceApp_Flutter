using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using SwimmingApp.Abstract.DTO;
using SwimmingApp.DAL.Logger;
using SwimmingApp.DAL.Repositories.TrainingDateService;
#nullable enable

namespace SwimmingAppWebAPI.Controllers
{
    [Route("trainingDate")]
    [ApiController]
    public class TrainingDateController : Controller
    {
        private readonly ITrainingDateService _trainingDateService;
        public TrainingDateController(ITrainingDateService trainingDateService)
        {
            _trainingDateService = trainingDateService;
        }

        [Authorize]
        [HttpGet]
        [Route("getTrainingDate/{currentDate?}")]
        public async Task<IActionResult> GetTrainingDate(DateTime? currentDate = null)
        {
            try
            {
                if (!int.TryParse(HttpContext?.User?.Claims?.FirstOrDefault(x => x.Type == "UserID")?.Value, out int userId))
                    return BadRequest("User not found.");

                var result = await _trainingDateService.GetTrainingDate(userId, currentDate);
                return Ok(result);
            }
            catch (Exception e)
            {
                await GlobalLogger.LogError(e);
                return StatusCode(500, new { Error = "Internal Server Error" });
            }
        }

        [HttpGet]
        [Authorize]
        [Route("getTrainingDateForEmployee/{currentDate?}")]
        public async Task<IActionResult> GetTrainingDateForEmployee(DateTime? currentDate = null)
        {
            try
            {
                var result = await _trainingDateService.GetTrainingDateForEmployee(currentDate);
                return Ok(result);
            }
            catch (Exception e)
            {
                await GlobalLogger.LogError(e);
                return StatusCode(500, new { Error = "Internal Server Error" });
            }
        }

        [Authorize]
        [HttpPost]
        [Route("addTrainingDate")]
        public async Task<IActionResult> InsertTrainingDate(TrainingDateDTO trainingDateDTO)
        {
            try
            {
                if (!int.TryParse(HttpContext?.User?.Claims?.FirstOrDefault(x => x.Type == "UserID")?.Value, out int userId))
                    return BadRequest("User not found.");

                var result = await _trainingDateService.InsertTrainingDate(trainingDateDTO, userId);
                return Ok(result);
            }
            catch (Exception e)
            {
                await GlobalLogger.LogError(e);
                return StatusCode(500, new { Error = "Internal Server Error" });
            }
        }

        [Authorize]
        [HttpPut]
        public async Task<IActionResult> UpdateTrainingResult(TrainingDateDTO trainingDateDTO)
        {
            try
            {
                var result = await _trainingDateService.UpdateTrainingDate(trainingDateDTO);
                return Ok(result);
            }
            catch (Exception e)
            {
                await GlobalLogger.LogError(e);
                return StatusCode(500, new { Error = "Internal Server Error" });
            }
        }

        [Authorize]
        [HttpDelete]
        [Route("deleteTrainingDate/{id}")]
        public async Task<IActionResult> DeleteTrainingDate(int id)
        {
            try
            {
                await _trainingDateService.DeleteTrainingDate(id);
                return Ok("Training date deleted");
            }
            catch (Exception e)
            {
                await GlobalLogger.LogError(e);
                return StatusCode(500, new { Error = "Internal Server Error" });
            }
        }
    }
}

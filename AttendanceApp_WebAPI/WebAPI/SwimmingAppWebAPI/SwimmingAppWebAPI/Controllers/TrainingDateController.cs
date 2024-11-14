using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using SwimmingApp.Abstract.DTO;
using SwimmingApp.DAL.Repositories.Log;
using SwimmingApp.DAL.Repositories.TrainingDateService;
#nullable enable

namespace SwimmingAppWebAPI.Controllers
{
    [Route("trainingDate")]
    [ApiController]
    public class TrainingDateController : Controller
    {
        private readonly TrainingDateService _trainingDateService;
        private readonly ErrorLogService _errorLogsService;
        public TrainingDateController(TrainingDateService trainingDateService, ErrorLogService errorLogsService)
        {
            _trainingDateService = trainingDateService;
            _errorLogsService = errorLogsService;
        }

        [Authorize]
        [HttpGet]
        [Route("getTrainingDate/{currentDate?}")]
        public async Task<IActionResult> GetTrainingDate(DateTime? currentDate = null)
        {
            try
            {
                var userId = HttpContext?.User.Claims.FirstOrDefault(x => x.Type == "UserID");
                if (userId == null)
                    return BadRequest("User not found.");

                var result = await _trainingDateService.GetTrainingDate(int.Parse(userId.Value), currentDate);
                return Ok(result);
            }
            catch (Exception e)
            {
                await _errorLogsService.LogError(e);
                return BadRequest($"{e.Message} {e.StackTrace}");
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
                await _errorLogsService.LogError(e);
                return StatusCode(StatusCodes.Status500InternalServerError, "An error occurred while processing your request.");
            }
        }

        [Authorize]
        [HttpPost]
        [Route("addTrainingDate")]
        public async Task<IActionResult> InsertTrainingDate(TrainingDateDTO trainingDateDTO)
        {
            try
            {
                var userId = HttpContext?.User.Claims.FirstOrDefault(x => x.Type == "UserID");
                if (userId == null)
                    return BadRequest("User not found.");

                var result = await _trainingDateService.InsertTrainingDate(trainingDateDTO, int.Parse(userId.Value));
                return Ok(result);
            }
            catch (Exception e)
            {
                await _errorLogsService.LogError(e);
                return BadRequest($"{e.Message}");
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
                await _errorLogsService.LogError(e);
                return BadRequest($"{e.Message}");
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
                await _errorLogsService.LogError(e);
                return BadRequest($"{e.Message}");
            }
        }
    }
}

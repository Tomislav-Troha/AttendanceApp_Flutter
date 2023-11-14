using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using SwimmingApp.Abstract.DTO;
using SwimmingApp.BL.Managers.Log;
using SwimmingApp.BL.Managers.TrainingDateManager;
#nullable enable

namespace SwimmingAppWebAPI.Controllers
{
    [Route("trainingDate")]
    [ApiController]
    public class TrainingDateController : Controller
    {
        private readonly TrainingDateManager _trainingDateManager;
        private readonly ErrorLogsManager _errorLogsManager;
        public TrainingDateController(TrainingDateManager trainingDateManager, ErrorLogsManager errorLogsManager)
        {
            _trainingDateManager = trainingDateManager;
            _errorLogsManager = errorLogsManager;
        }

        [Authorize]
        [HttpGet]
        [Route("getTrainingDate/{currentDate?}")]
        public async Task<IActionResult> GetTrainingDate(DateTime? currentDate = null)
        {
            try
            {
                var userID = HttpContext?.User.Claims.Where(x => x.Type == "UserID").Single();
                var result = await _trainingDateManager.GetTrainingDate(int.Parse(userID.Value), currentDate);
                return Ok(result);
            }
            catch (Exception e)
            {
                await _errorLogsManager.LogError(e);
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
                var result = await _trainingDateManager.GetTrainingDateForEmployee(currentDate);
                return Ok(result);
            }
            catch (Exception e)
            {
                await _errorLogsManager.LogError(e);
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
                var userID = HttpContext?.User.Claims.Where(x => x.Type == "UserID").Single();
                var result = await _trainingDateManager.InsertTrainingDate(trainingDateDTO, int.Parse(userID.Value));
                return Ok(result);
            }
            catch (Exception e)
            {
                await _errorLogsManager.LogError(e);
                return BadRequest($"{e.Message}");
            }
        }

        [Authorize]
        [HttpPut]
        public async Task<IActionResult> UpdateTrainingResult(TrainingDateDTO trainingDateDTO)
        {
            try
            {
                var result = await _trainingDateManager.UpdateTrainingDate(trainingDateDTO);
                return Ok(result);
            }
            catch (Exception e)
            {
                await _errorLogsManager.LogError(e);
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
                await _trainingDateManager.DeleteTrainingDate(id);
                return Ok("Training date deleted");
            }
            catch (Exception e)
            {
                await _errorLogsManager.LogError(e);
                return BadRequest($"{e.Message}");
            }
        }
    }
}

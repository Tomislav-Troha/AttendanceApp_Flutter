using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using SwimmingApp.Abstract.DTO;
using SwimmingApp.BL.Managers.Log;
using SwimmingApp.BL.Managers.TrainingManager;

namespace SwimmingAppWebAPI.Controllers
{
    [Route("training")]
    [ApiController]
    public class TrainingController : Controller
    {
        private readonly TrainingManager _trainingManager;
        private readonly ErrorLogsManager _errorLogsManager;

        public TrainingController(TrainingManager trainingManager, ErrorLogsManager errorLogsManager)
        {
            _trainingManager = trainingManager;
            _errorLogsManager = errorLogsManager;
        }


        [HttpGet]
        [Route("getTraining")]
        public async Task<IActionResult> GetTraining(int? id = null)
        {
            try
            {
                var response = await _trainingManager.GetTraining(id);
                return Ok(response);
            }
            catch (Exception e)
            {
                await _errorLogsManager.LogError(e);
                return BadRequest(e);
            }
        }

        [Authorize]
        [HttpPost]
        [Route("postTraining")]
        public async Task<IActionResult> InsertTraining(TrainingDTO model)
        {
            try
            {
                var result = await _trainingManager.InsertTraining(model);
                return Ok(result);
            }
            catch (Exception e)
            {
                await _errorLogsManager.LogError(e);
                return BadRequest(e);
            }
        }

        [Authorize]
        [HttpPut]
        [Route("updateTraining")]
        public async Task<IActionResult> UpdateTraining(TrainingDTO model)
        {
            try
            {
                var result = await _trainingManager.UpdateTraining(model);
                return Ok(result);
            }
            catch (Exception e)
            {
                await _errorLogsManager.LogError(e);
                return BadRequest(e);
            }
        }

        [Authorize]
        [HttpDelete]
        [Route("deleteTraining/{id}")]
        public async Task<IActionResult> DeleteTraining(int id)
        {
            try
            {
                await _trainingManager.DeleteTraining(id);
                return Ok();
            }
            catch (Exception e)
            {
                await _errorLogsManager.LogError(e);
                return BadRequest(e);
            }
        }

    }
}

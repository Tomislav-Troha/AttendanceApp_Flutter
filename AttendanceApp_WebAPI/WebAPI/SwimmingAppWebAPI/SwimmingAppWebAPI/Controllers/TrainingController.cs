using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using SwimmingApp.Abstract.DTO;
using SwimmingApp.DAL.Logger;
using SwimmingApp.DAL.Repositories.TrainingService;

namespace SwimmingAppWebAPI.Controllers
{
    [Route("training")]
    [ApiController]
    public class TrainingController : Controller
    {
        private readonly ITrainingService _trainingService;

        public TrainingController(ITrainingService trainingManager)
        {
            _trainingService = trainingManager;
        }

        [HttpGet]
        [Route("getTraining")]
        public async Task<IActionResult> GetTraining(int? id = null)
        {
            try
            {
                var response = await _trainingService.GetTraining(id);
                return Ok(response);
            }
            catch (Exception e)
            {
                await GlobalLogger.LogError(e);
                return StatusCode(500, new { Error = "Internal Server Error" });
            }
        }

        [Authorize]
        [HttpPost]
        [Route("postTraining")]
        public async Task<IActionResult> InsertTraining(TrainingDTO model)
        {
            try
            {
                var result = await _trainingService.InsertTraining(model);
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
        [Route("updateTraining")]
        public async Task<IActionResult> UpdateTraining(TrainingDTO model)
        {
            try
            {
                var result = await _trainingService.UpdateTraining(model);
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
        [Route("deleteTraining/{id}")]
        public async Task<IActionResult> DeleteTraining(int id)
        {
            try
            {
                await _trainingService.DeleteTraining(id);
                return Ok();
            }
            catch (Exception e)
            {
                await GlobalLogger.LogError(e);
                return StatusCode(500, new { Error = "Internal Server Error" });
            }
        }

    }
}

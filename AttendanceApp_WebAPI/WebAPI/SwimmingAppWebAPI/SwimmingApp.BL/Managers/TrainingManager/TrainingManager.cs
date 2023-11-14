using SwimmingApp.Abstract.DataModel;
using SwimmingApp.Abstract.DTO;
using SwimmingApp.DAL.Repositories.TrainingService;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SwimmingApp.BL.Managers.TrainingManager
{
    public class TrainingManager
    {
        private readonly ITrainingService _trainingService;
        public TrainingManager(ITrainingService trainingService)
        {
            _trainingService = trainingService;
        }

        public async Task<IEnumerable<TrainingDTO>> GetTraining(int? id)
        {
            var training = await _trainingService.GetTraining(id);

            List<TrainingDTO> trainingDTOs= new List<TrainingDTO>();

            foreach (var train in training)
            {
                trainingDTOs.Add(new TrainingDTO(train));
            }
            return trainingDTOs;
        }

        public async Task<TrainingDTO> InsertTraining(TrainingDTO model)
        {
            return await _trainingService.InsertTraining(model);
        }

        public async Task<TrainingDTO> UpdateTraining(TrainingDTO model)
        {
            return await _trainingService.UpdateTraining(model);
        }

        public async Task DeleteTraining(int id)
        {
            await _trainingService.DeleteTraining(id);
        }
    }
}

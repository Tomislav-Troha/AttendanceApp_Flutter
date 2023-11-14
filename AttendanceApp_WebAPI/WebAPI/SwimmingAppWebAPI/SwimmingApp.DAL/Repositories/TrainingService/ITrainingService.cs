using SwimmingApp.Abstract.DataModel;
using SwimmingApp.Abstract.DTO;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SwimmingApp.DAL.Repositories.TrainingService
{
    public interface ITrainingService
    {
        Task<IEnumerable<TrainingModel>> GetTraining(int? id);
        Task<TrainingDTO> InsertTraining(TrainingDTO trainingDTO);
        Task<TrainingDTO> UpdateTraining(TrainingDTO trainingDTO);
        Task DeleteTraining(int id);
    }
}

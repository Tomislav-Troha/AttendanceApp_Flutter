using SwimmingApp.Abstract.DataModel;
using SwimmingApp.Abstract.DTO;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SwimmingApp.DAL.Repositories.TrainingDateService
{
    public interface ITrainingDateService
    {
        Task<List<TrainingDateModel>> InsertTrainingDate(TrainingDateDTO trainingDateDTO, int userID);

        Task<TrainingDateDTO> UpdateTrainingDate(TrainingDateDTO trainingDateDTO);

        Task<IEnumerable<TrainingDateDTO>> GetTrainingDate(int userID, DateTime? currentDate);

        Task DeleteTrainingDate(int id);

        Task<IEnumerable<TrainingDateModel>> GetTrainingDateForEmployee(DateTime? currentDate);
    }
}

using SwimmingApp.Abstract.DataModel;
using SwimmingApp.Abstract.DTO;

namespace SwimmingApp.DAL.Repositories.TrainingDateService
{
    public interface ITrainingSessionService
    {
        Task<List<TrainingSessionModel>?> InsertTrainingSession(TrainingSessionDTO trainingDateDTO, int userID);

        Task<TrainingSessionDTO?> UpdateTrainingSession(TrainingSessionDTO trainingDateDTO);

        Task<IEnumerable<TrainingSessionDTO>?> GetTrainingSession(int userID, DateTime? currentDate);

        Task DeleteTrainingSession(int id);

        Task<IEnumerable<TrainingSessionModel>?> GetTrainingSessionsForEmployee(DateTime? currentDate);
    }
}

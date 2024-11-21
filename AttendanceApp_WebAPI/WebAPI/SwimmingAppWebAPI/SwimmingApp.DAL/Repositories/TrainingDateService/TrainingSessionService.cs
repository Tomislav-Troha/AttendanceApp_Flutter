using Dapper;
using SwimmingApp.Abstract.DataModel;
using SwimmingApp.Abstract.DTO;
using SwimmingApp.DAL.Contex;
using SwimmingApp.DAL.Core;

namespace SwimmingApp.DAL.Repositories.TrainingDateService
{
    public class TrainingSessionService : ITrainingSessionService
    {

        private readonly IDbService _db;
        private readonly DapperContext _contex;

        public TrainingSessionService(IDbService dbService, DapperContext context)
        {
            _db = dbService;
            _contex = context;
        }

        public async Task DeleteTrainingSession(int id)
        {
            DynamicParameters param = new DynamicParameters();
            param.Add("id", id);

            await _db.DeleteAsync("CALL TrainingSession_Delete(@id)", param);
        }

        public async Task<IEnumerable<TrainingSessionDTO>?> GetTrainingSession(int userID, DateTime? currentDate)
        {
            DynamicParameters param = new DynamicParameters();
            param.Add("userId", userID);
            param.Add("currentDate", currentDate);

            var query = "SELECT * FROM TrainingSession_Select(@userId, @currentDate)";
            using var connection = _contex.CreateConnection();

            IEnumerable<TrainingSessionDTO> trainingSessions = await connection.QueryAsync<TrainingSessionDTO, TrainingModel, UserModel, UserRoleModel, TrainingSessionDTO>(query,
                (trainingSession, training, user, userRole) =>
                {
                    trainingSession.TrainingModel = training;
                    trainingSession.TrainerModel = user;
                    trainingSession.UserRoleModel = userRole;
                    return trainingSession;
                }, param, splitOn: "TrainingID, UserID, RoleId");

            return trainingSessions;
        }

        public async Task<IEnumerable<TrainingSessionModel>?> GetTrainingSessionsForEmployee(DateTime? currentDate)
        {
            DynamicParameters param = new DynamicParameters();
            param.Add("currentDate", currentDate);

            var query = "SELECT * FROM TrainingSession_Select_ForEmployee(@currentDate)";
            using var connection = _contex.CreateConnection();

            IEnumerable<TrainingSessionModel> trainingSessionsEmployee = await connection.QueryAsync<TrainingSessionModel, TrainingModel, UserModel, TrainingSessionModel>(query,
                (trainingSession, training, user) =>
                {
                    trainingSession.TrainingModel = training;
                    trainingSession.TrainerModel = user;
                    return trainingSession;
                }, param, splitOn: "TrainingID, UserID");

            return trainingSessionsEmployee;
        }

        public async Task<List<TrainingSessionModel>?> InsertTrainingSession(TrainingSessionDTO trainingSessionDTO, int userID)
        {
            List<TrainingSessionModel> newTrainingSession = new List<TrainingSessionModel>();
            var query = "SELECT * FROM TrainingSession_Insert(@e_timeFrom, @e_timeTo, @e_trainingID, @e_trainerID)";
            using var connection = _contex.CreateConnection();

            if (trainingSessionDTO?.UsersModel != null)
            {
                foreach (var user in trainingSessionDTO.UsersModel)
                {
                    DynamicParameters param = new DynamicParameters();
                    param.Add("startDateTime", trainingSessionDTO?.StartDateTime);
                    param.Add("endDateTime", trainingSessionDTO?.EndDateTime);
                    param.Add("trainingID", trainingSessionDTO?.TrainingModel?.ID);
                    param.Add("trainerID", user?.ID);

                    IEnumerable<TrainingSessionModel> result = await connection.QueryAsync<TrainingSessionModel, TrainingModel, UserModel, TrainingSessionModel>(query,
                    (trainingSession, training, user) =>
                    {
                        trainingSession.TrainingModel = training;
                        trainingSession.TrainerModel = user;
                        return trainingSession;
                    }, param, splitOn: "TrainingID, UserId");

                    if (result != null)
                        newTrainingSession.AddRange(result);
                }
            }
            return newTrainingSession;
        }

        public async Task<TrainingSessionDTO?> UpdateTrainingSession(TrainingSessionDTO trainingSessionDTO)
        {
            DynamicParameters param = new DynamicParameters();
            param.Add("id", trainingSessionDTO?.ID);
            param.Add("timeFrom", trainingSessionDTO?.StartDateTime);
            param.Add("timeTo", trainingSessionDTO?.EndDateTime);
            param.Add("trainingID", trainingSessionDTO?.TrainingModel?.ID);
            param.Add("trainerID", trainingSessionDTO?.TrainerModel?.ID);

            await _db.UpdateAsync("CALL TrainingSession_Update(@id, @timeFrom, @timeTo, @trainingID, @trainerID)", param);

            return trainingSessionDTO;
        }
    }
}

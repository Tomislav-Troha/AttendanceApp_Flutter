using Dapper;
using SwimmingApp.Abstract.DataModel;
using SwimmingApp.Abstract.DTO;
using SwimmingApp.DAL.Contex;
using SwimmingApp.DAL.Core;

namespace SwimmingApp.DAL.Repositories.TrainingDateService
{
    public class TrainingDateService : ITrainingDateService
    {

        private readonly IDbService _db;
        private readonly DapperContext _contex;

        public TrainingDateService(IDbService dbService, DapperContext context)
        {
            _db = dbService;
            _contex = context;
        }

        public async Task DeleteTrainingDate(int id)
        {
            DynamicParameters param = new DynamicParameters();
            param.Add("id", id);

            await _db.DeleteAsync("CALL TrainingDate_Delete(@id)", param);
        }

        public async Task<IEnumerable<TrainingDateDTO>> GetTrainingDate(int userID, DateTime? currentDate)
        {
           
            DynamicParameters param = new DynamicParameters();
            param.Add("userId", userID);
            param.Add("currentDate", currentDate);

            var query = "SELECT * FROM TrainingDate_Select(@userId, @currentDate)";
            using var connection = _contex.CreateConnection();

            IEnumerable<TrainingDateDTO> trainingDates = await connection.QueryAsync<TrainingDateDTO, TrainingModel, UserModel, UserRoleModel, TrainingDateDTO>(query,
                (trainingDate, training, user, userRole) =>
                {
                    trainingDate.TrainingModel = training;
                    trainingDate.UserModel = user;
                    trainingDate.UserRoleModel = userRole;
                    return trainingDate;
                }, param, splitOn: "ID_training, userId, RoleId");

            return trainingDates;

            //--ovo bi se koristilo kad si PostrgreSQL mogao u funkciji/proceduri selectati vise querya od jednom, onda bi sa Dapperom joinao u kodu--
            //var result = await connection.QueryMultipleAsync(query, param);

            //List<TrainingDateModel> trainingDateModels = result.Read<TrainingDateModel>().ToList();
            //List<MemberModel> memberModels = result.Read<MemberModel>().ToList();
            //List<TrainingModel> trainingModels = result.Read<TrainingModel>().ToList();

            //foreach (TrainingDateModel traDateModel in trainingDateModels)
            //{
            //    //traDateModel.MemberModel.AddRange(memberModels.Where(x => x.ID_member == traDateModel.MemberID));
            //    //traDateModel.TrainingModel.AddRange(trainingModels.Where(x => x.ID_training == traDateModel.TrainingID));
            //}

            //return trainingDateModels;

        }

        public async Task<IEnumerable<TrainingDateModel>> GetTrainingDateForEmployee(DateTime? currentDate)
        {
            DynamicParameters param = new DynamicParameters();
            param.Add("currentDate", currentDate);

            var query = "SELECT * FROM TrainingDate_Select_ForEmployee(@currentDate)";
            using var connection = _contex.CreateConnection();

            IEnumerable<TrainingDateModel> trainingDateEmployee = await connection.QueryAsync<TrainingDateModel, TrainingModel, UserModel, TrainingDateModel>(query,
                (trainingDate, training, user) =>
                {
                    trainingDate.TrainingModel = training;
                    trainingDate.UserModel = user;
                    return trainingDate;
                }, param, splitOn: "id_training, userID");

            return trainingDateEmployee;
        }

        public async Task<TrainingDateDTO> InsertTrainingDate(TrainingDateDTO trainingDateDTO, int userID)
        {

            foreach (var item in trainingDateDTO.UserModelList)
            {
                DynamicParameters param = new DynamicParameters();
                param.Add("dates", trainingDateDTO.Dates);
                param.Add("timeFrom", trainingDateDTO.TimeFrom);
                param.Add("timeTo", trainingDateDTO.TimeTo);
                param.Add("trainingID", trainingDateDTO.TrainingModel.ID_training);
                param.Add("UserID", item.UserId);

                await _db.InsertAsync("CALL TrainingDate_Insert(@dates, @timeFrom, @timeTo, @trainingID, @userID)", param);
            }

            return trainingDateDTO;
        }

        public async Task<TrainingDateDTO> UpdateTrainingDate(TrainingDateDTO trainingDateDTO)
        {
            DynamicParameters param = new DynamicParameters();
            param.Add("id", trainingDateDTO.ID_TrainingDate);
            param.Add("dates", trainingDateDTO.Dates);
            param.Add("timeFrom", trainingDateDTO.TimeFrom);
            param.Add("timeTo", trainingDateDTO.TimeTo);
            param.Add("trainingID", trainingDateDTO.TrainingModel.ID_training);

            await _db.UpdateAsync("CALL TrainingDate_Update(@id, @dates, @timeFrom, @timeTo, @trainingID)", param);

            return trainingDateDTO;
        }
    }
}

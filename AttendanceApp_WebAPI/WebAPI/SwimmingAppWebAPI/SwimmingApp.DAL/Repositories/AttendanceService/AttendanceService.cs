using Dapper;
using SwimmingApp.Abstract.DataModel;
using SwimmingApp.Abstract.DTO;
using SwimmingApp.DAL.Contex;
using SwimmingApp.DAL.Core;

namespace SwimmingApp.DAL.Repositories.AttendanceService
{
    public class AttendanceService : IAttendanceService
    {
        private readonly IDbService _db;
        private readonly DapperContext _contex;
        public AttendanceService(IDbService dbService, DapperContext context)
        {
            _db = dbService;
            _contex = context;
        }

        public async Task DeleteAttendance(int? id)
        {
            DynamicParameters param = new DynamicParameters();
            param.Add("id", id);

            await _db.DeleteAsync("CALL Attendance_Delete(@id)", param);
        }

        public async Task<IEnumerable<AttendanceModel>> GetAttendanceByUserID(int? userID)
        {
            DynamicParameters param = new DynamicParameters();
            param.Add("userId", userID);

            var query = "SELECT * FROM Attendance_Select_ByUser(@userId)";
            using var connection = _contex.CreateConnection();

            IEnumerable<AttendanceModel> attendances = await connection.QueryAsync<AttendanceModel, TrainingModel, UserModel, TrainingDateModel, UserRoleModel, AttendanceModel>(query,
                (attendance, training, user, trainingDate, userRole) =>
                {
                    attendance.TrainingModel = training;
                    attendance.UserModel = user;
                    attendance.TrainingDateModel = trainingDate;
                    attendance.UserRoleModel = userRole;
                    return attendance;
                }, param, splitOn: "ID_training, userId, ID_trainingDate, roleID");

            return attendances;
        }

        public async Task<IEnumerable<AttendanceModel>> GetAttendanceAll(int? userID)
        {
            DynamicParameters param = new DynamicParameters();
            param.Add("userId", userID);

            var query = "SELECT * FROM Attendance_SelectAll(@userID)";
            using var connection = _contex.CreateConnection();

            IEnumerable<AttendanceModel> attendances = await connection.QueryAsync<AttendanceModel, TrainingModel, UserModel, TrainingDateModel, UserRoleModel, AttendanceModel>(query,
                (attendance, training, user, trainingDate, userRole) =>
                {
                    attendance.TrainingModel = training;
                    attendance.UserModel = user;
                    attendance.TrainingDateModel = trainingDate;
                    attendance.UserRoleModel = userRole;
                    return attendance;
                }, param, splitOn: "ID_training, userId, ID_trainingDate, roleID");

            return attendances;
        }

        public async Task<AttendanceDTO> InsertAttendance(AttendanceDTO attendanceDTO, int? userID)
        {
            DynamicParameters param = new DynamicParameters();
            param.Add("attDesc", attendanceDTO.AttDesc);
            param.Add("type", attendanceDTO.Type);
            param.Add("trainingID", attendanceDTO.TrainingModel?.ID_training);
            param.Add("userID", userID);
            param.Add("trainingDateID", attendanceDTO.TrainingDateModel?.ID_TrainingDate);

            await _db.InsertAsync("CALL Attendance_Insert(@attDesc, @type, @trainingID, @userID, @trainingDateID)", param);

            return attendanceDTO;
        }

        public async Task<AttendanceDTO> InsertAttendanceNotSubmitted(AttendanceDTO attendanceDTO, int? userID)
        {
            DynamicParameters param = new DynamicParameters();
            param.Add("attDesc", attendanceDTO.AttDesc);
            param.Add("type", attendanceDTO.Type);
            param.Add("trainingID", attendanceDTO.TrainingModel?.ID_training);
            param.Add("userID", userID);
            param.Add("trainingDateID", attendanceDTO.TrainingDateModel?.ID_TrainingDate);

            await _db.InsertAsync("CALL Attendance_Insert(@attDesc, @type, @trainingID, @userID, @trainingDateID)", param);

            return attendanceDTO;
        }
    }
}

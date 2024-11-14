using SwimmingApp.Abstract.DataModel;
using SwimmingApp.Abstract.DTO;
using SwimmingApp.DAL.Repositories.AttendanceService;

namespace SwimmingApp.BL.Managers.AttendanceManager
{
    public class AttendanceManager
    {
        private readonly IAttendanceService _attendanceService;

        public AttendanceManager(IAttendanceService attendanceService)
        {
            _attendanceService = attendanceService;
        }

        public async Task<AttendanceDTO> InsertAttendance(AttendanceDTO attendanceDTO, int userID)
        {
            return await _attendanceService.InsertAttendance(attendanceDTO, userID);
        }

        public async Task<AttendanceDTO> InsertAttendanceNotSubmitted(AttendanceDTO attendanceDTO, int? userID)
        {
            return await _attendanceService.InsertAttendanceNotSubmitted(attendanceDTO, userID);
        }

        public async Task<IEnumerable<AttendanceModel>> GetAttendanceByUser(int userId)
        {
            return await _attendanceService.GetAttendanceByUserID(userId);
        }

        public async Task DeleteAttendance(int id)
        {
            await _attendanceService.DeleteAttendance(id);
        }

        public async Task<IEnumerable<AttendanceModel>> GetAttendanceAll(int? userID)
        {
            return await _attendanceService.GetAttendanceAll(userID);
        }
    }
}

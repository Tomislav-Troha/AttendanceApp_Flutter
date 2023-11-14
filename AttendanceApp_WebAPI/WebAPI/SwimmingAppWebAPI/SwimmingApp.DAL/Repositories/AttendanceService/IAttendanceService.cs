using SwimmingApp.Abstract.DataModel;
using SwimmingApp.Abstract.DTO;

namespace SwimmingApp.DAL.Repositories.AttendanceService
{
    public interface IAttendanceService
    {
        Task<AttendanceDTO> InsertAttendance(AttendanceDTO attendanceDTO, int userID);
        Task<AttendanceDTO> InsertAttendanceNotSubmitted(AttendanceDTO attendanceDTO, int userID);

        Task<IEnumerable<AttendanceModel>> GetAttendanceByUserID(int userID);

        Task DeleteAttendance(int id);

        Task<IEnumerable<AttendanceModel>> GetAttendanceAll(int? userID);

    }
}

using System.ComponentModel.DataAnnotations.Schema;

namespace SwimmingApp.Abstract.Data
{
    public class Attendance
    {
        [Column("AttendanceID ")]
        public int? ID { get; set; }
        public int? UserID { get; set; }
        public int? TrainingSessionID { get; set; }
        public string? Status { get; set; }
        public DateTime? AttendanceDateTime { get; set; }
    }
}

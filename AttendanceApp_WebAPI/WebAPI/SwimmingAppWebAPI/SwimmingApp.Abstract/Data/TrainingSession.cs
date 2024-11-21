using System.ComponentModel.DataAnnotations.Schema;

namespace SwimmingApp.Abstract.Data
{
    public class TrainingSession
    {
        [Column("TrainingSessionID")]
        public int? ID { get; set; }
        public int? TrainingID { get; set; }
        public int? TrainerID { get; set; }
        public DateTime? StartDateTime { get; set; }
        public DateTime? EndDateTime { get; set; }
    }
}

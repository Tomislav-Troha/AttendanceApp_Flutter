using System.ComponentModel.DataAnnotations.Schema;

namespace SwimmingApp.Abstract.Data
{
    public class Training
    {
        [Column("TrainingID")]
        public int? ID { get; set; }
        public string? Code { get; set; }
        public string? TrainingType { get; set; }
        public string? Title { get; set; }
        public string? Description { get; set; }
    }
}

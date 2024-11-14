namespace SwimmingApp.Abstract.Data
{
    public class TrainingDate
    {
        public int? ID_TrainingDate { get; set; }
        public DateTime? Dates { get; set; }
        public DateTime? TimeFrom { get; set; }
        public DateTime? TimeTo { get; set; }
        public int? TrainingID { get; set; }
        public int? UserID { get; set; }

    }
}

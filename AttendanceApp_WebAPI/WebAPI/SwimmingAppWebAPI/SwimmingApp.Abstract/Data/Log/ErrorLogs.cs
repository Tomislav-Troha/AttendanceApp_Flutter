namespace SwimmingApp.Abstract.Data.Log
{
    public class ErrorLogs
    {
        public int Id { get; set; }
        public DateTime Timestamp { get; set; }
        public string Source { get; set; }
        public string Message { get; set; }
        public string StackTrace { get; set; }
        public string AdditionalInfo { get; set; } // JSON string
    }

}

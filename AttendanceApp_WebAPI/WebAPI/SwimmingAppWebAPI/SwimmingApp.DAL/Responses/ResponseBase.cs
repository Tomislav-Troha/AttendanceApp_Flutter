namespace SwimmingApp.DAL.Responses
{
    public class ResponseBase
    {
        public bool Success { get; set; }
        public List<string> Errors { get; set; }

        public ResponseBase()
        {
            Success = true;
            Errors = new List<string>();
        }
    }
}

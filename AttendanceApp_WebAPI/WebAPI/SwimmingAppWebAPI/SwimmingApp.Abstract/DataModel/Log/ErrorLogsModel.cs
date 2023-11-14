using SwimmingApp.Abstract.Data.Log;

namespace SwimmingApp.Abstract.DataModel.Log
{
    public class ErrorLogsModel : ErrorLogs
    {
        public ErrorLogsModel()
        {
        }

        public ErrorLogsModel(ErrorLogsModel model)
        {
            Id = model.Id;
            Timestamp = model.Timestamp;
            Source = model.Source;
            Message = model.Message;
            StackTrace = model.StackTrace;
            AdditionalInfo = model.AdditionalInfo;
        }
    }
}

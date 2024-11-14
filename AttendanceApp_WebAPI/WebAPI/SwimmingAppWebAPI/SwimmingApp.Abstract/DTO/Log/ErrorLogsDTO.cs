using SwimmingApp.Abstract.DataModel.Log;

namespace SwimmingApp.Abstract.DTO.Log
{
    public class ErrorLogsDTO : ErrorLogsModel
    {
        public ErrorLogsDTO(ErrorLogsModel model)
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

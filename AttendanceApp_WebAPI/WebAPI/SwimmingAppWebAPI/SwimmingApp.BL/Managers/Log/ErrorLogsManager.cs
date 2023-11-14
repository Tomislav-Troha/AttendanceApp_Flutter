using SwimmingApp.DAL.Repositories.Log;

namespace SwimmingApp.BL.Managers.Log
{
    public class ErrorLogsManager
    {
        private readonly IErrorLogService _errorLogService;
        public ErrorLogsManager(IErrorLogService errorLogService)
        {
            _errorLogService = errorLogService;
        }

        public async Task LogError(Exception e)
        {
            await _errorLogService.LogError(e);
        }
    }
}

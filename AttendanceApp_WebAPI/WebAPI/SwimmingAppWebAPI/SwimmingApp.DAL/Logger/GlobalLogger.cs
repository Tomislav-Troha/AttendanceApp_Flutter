using SwimmingApp.DAL.Repositories.Log;

namespace SwimmingApp.DAL.Logger
{
    public static class GlobalLogger
    {
        private static IErrorLogService? _errorLogService;

        public static void Initialize(IErrorLogService errorLogService)
        {
            _errorLogService = errorLogService;
        }

        public static async Task LogError(Exception e)
        {
            if (_errorLogService == null)
                throw new InvalidOperationException("GlobalErrorLogger is not initialized. Ensure Initialize() is called during application startup.");

            await _errorLogService.LogError(e);
        }
    }
}

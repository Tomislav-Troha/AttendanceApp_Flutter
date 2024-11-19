using Microsoft.Extensions.DependencyInjection;
using SwimmingApp.DAL.Repositories.Log;

namespace SwimmingApp.DAL.Logger
{
    public static class GlobalLogger
    {
        private static IServiceProvider? _serviceProvider;

        public static void Initialize(IServiceProvider serviceProvider)
        {
            _serviceProvider = serviceProvider;
        }

        public static async Task LogError(Exception e)
        {
            if (_serviceProvider == null)
                throw new InvalidOperationException("GlobalErrorLogger is not initialized. Ensure Initialize() is called during application startup.");
            
            using var scope = _serviceProvider.CreateScope();
            var errorLogService = scope.ServiceProvider.GetRequiredService<IErrorLogService>();
            await errorLogService.LogError(e);
        }
    }
}

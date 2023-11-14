using Dapper;
using SwimmingApp.DAL.Core;
using SwimmingApp.DAL.Helper;

namespace SwimmingApp.DAL.Repositories.Log
{
    public class ErrorLogService : IErrorLogService
    {
        private readonly IDbService _db;
        public ErrorLogService(IDbService dbService)
        {
            _db = dbService;
        }
        public async Task LogError(Exception e)
        {
            {
                DynamicParameters param = new DynamicParameters();
                param.Add("source", e.Source);
                param.Add("message", e.Message);
                param.Add("stack_trace", e.StackTrace);
                param.Add("additional_info", ExceptionHelper.GetMethodSignature(e));

                await _db.InsertAsync("CALL Log_Insert(@source, @message, @stack_trace, @additional_info)", param);

            }
        }
    }
}

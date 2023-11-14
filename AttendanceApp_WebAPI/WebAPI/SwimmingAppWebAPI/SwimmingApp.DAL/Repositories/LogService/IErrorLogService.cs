namespace SwimmingApp.DAL.Repositories.Log
{
    public interface IErrorLogService
    {
        Task LogError(Exception e);
    }
}

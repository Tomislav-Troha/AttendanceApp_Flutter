namespace SwimmingApp.DAL.Core
{
    public interface IDbService
    {
        Task<IEnumerable<T>> GetAsync<T>(string? command, object? parms = null);
        Task<T> FindOneAsync<T>(string? command, object? parms = null);
        Task<int> UpdateAsync(string? command, object? parms = null);
        Task<DbInsertResult> InsertAsync(string? command, object? parms = null);
        Task<int> DeleteAsync(string? command, object? parms = null);
    }
}

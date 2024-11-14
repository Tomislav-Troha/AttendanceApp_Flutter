using System.Data;
using Dapper;
using Microsoft.Extensions.Configuration;
using Npgsql;

namespace SwimmingApp.DAL.Core
{
    public class DbService : IDbService
    {
        private readonly IDbConnection _db;

        public DbService(IConfiguration configuration)
        {
            _db = new NpgsqlConnection(configuration.GetConnectionString("SwimmingAplication"));
        }

        public async Task<DbInsertResult> InsertAsync(string? command, object? parms)
        {
            var query = await _db.QueryAsync(command, parms);
            var result = query.FirstOrDefault();

            if (result == null)
            {
                return new DbInsertResult(0, null, null);
            }
            var rowCount = Convert.ToInt32(result.RowCount);
            if (rowCount > 0)
            {
                return new DbInsertResult(rowCount, result.Id, result);
            }
            return new DbInsertResult(rowCount, null, result);
        }

        public async Task<IEnumerable<T>> GetAsync<T>(string? command, object? parms)
        {
            var result = await _db.QueryAsync<T>(command, parms);
            return result;
        }

        public async Task<T> FindOneAsync<T>(string? command, object? parms)
        {
            var result = await _db.QuerySingleAsync<T>(command, parms);
            return result;
        }

        public async Task<int> UpdateAsync(string? command, object? parms)
        {
            var query = await _db.QueryAsync(command, parms);
            var result = query.FirstOrDefault();
            if (result == null)
            {
                return 0;
            }
            return Convert.ToInt32(result.RowCount);
        }

        public async Task<int> DeleteAsync(string? command, object? parms)
        {
            var query = await _db.QueryAsync(command, parms);
            var result = query.FirstOrDefault();
            if (result == null)
            {
                return 0;
            }
            return Convert.ToInt32(result.RowCount);
        }
    }
}

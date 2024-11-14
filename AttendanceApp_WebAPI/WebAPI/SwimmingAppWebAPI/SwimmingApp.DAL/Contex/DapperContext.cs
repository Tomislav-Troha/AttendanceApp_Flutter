using System.Data;
using Microsoft.Extensions.Configuration;
using Npgsql;

namespace SwimmingApp.DAL.Contex
{
    public class DapperContext
    {
        private readonly IConfiguration? _configuration;
        private readonly string _connectionString;

        public DapperContext(IConfiguration configuration)
        {
            _configuration = configuration;
            _connectionString = _configuration.GetConnectionString("SwimmingAplication")!;
        }

        public IDbConnection CreateConnection() => new NpgsqlConnection(_connectionString);
    }
}

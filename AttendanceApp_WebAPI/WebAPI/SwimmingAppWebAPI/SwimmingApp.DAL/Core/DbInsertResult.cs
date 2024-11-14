namespace SwimmingApp.DAL.Core
{
    public class DbInsertResult
    {
        public DbInsertResult(int rowsChanged, object? id, dynamic? queryResult)
        {
            RowsChanged = rowsChanged;
            Id = id;
            QueryResult = queryResult;
        }

        public int RowsChanged { get; protected set; }
        public object? Id { get; protected set; }
        public dynamic? QueryResult { get; protected set; }
    }
}

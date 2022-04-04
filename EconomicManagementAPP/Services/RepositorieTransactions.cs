using EconomicManagementAPP.Models;
using EconomicManagementAPP.Repositories;
using Microsoft.Data.SqlClient;
using Dapper;

namespace EconomicManagementAPP.Services
{
    public class RepositorieTransactions : IRepositorieTransactions
    {
        private readonly string connectionString;
        public RepositorieTransactions(IConfiguration configuration)
        {
            connectionString = configuration.GetConnectionString("DefaultConnection");
        }

        public async Task Create(Transactions transactions)
        {
            using var connection = new SqlConnection(connectionString);
            var id = await connection.QuerySingleAsync<int>
                (@"Transactions_Insert",
                            new
                            {
                                transactions.UserId,
                                transactions.TransactionDate,
                                transactions.Total,
                                transactions.CategoryId,
                                transactions.AccountId,
                                transactions.Description
                            },
                              commandType: System.Data.CommandType.StoredProcedure);

            transactions.Id = id;
        }



        public async Task<Transactions> GetTransactionById(int id, int userId)
        {
            using var connection = new SqlConnection(connectionString);
            return await connection.QueryFirstOrDefaultAsync<Transactions>(@"
                                                                SELECT Id, UserId, TransactionDate, Total, Description, AccountId, CategoryId
                                                                FROM Transactions
                                                                WHERE Id = @Id AND UserID = @UserID",
                                                                new { id, userId });

        }

        public async Task ModifyTransaction(Transactions transactions)
        {
            using var connection = new SqlConnection(connectionString);
            await connection.ExecuteAsync(@"Update Transactions
                    set Total=@Total, Description=@Description
                        WHERE Id = @Id;", transactions);
        }

        public async Task Delete(int id)
        {
            using var connection = new SqlConnection(connectionString);
            await connection.ExecuteAsync("DELETE Transactions WHERE Id = @Id", new { id });
        }

    }
}

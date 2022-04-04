using EconomicManagementAPP.Models;

namespace EconomicManagementAPP.Repositories
{
    public interface IRepositorieTransactions
    {
        Task Create(Transactions transactions);

        Task ModifyTransaction(Transactions transactions);

        Task Delete(int Id);

        Task<Transactions> GetTransactionById(int Id, int UserId);
    }
}


using EconomicManagementAPP.Models;

public interface IRepositorieAccountTypes
{
    Task Create(AccountTypes accountTypes); // Se agrega task por el asincronismo

    Task<bool> Exist(string Name, int UserId);

    Task<IEnumerable<AccountTypes>> getAccounts(int UserId);

    Task Modify(AccountTypes accountTypes);

    Task<AccountTypes> getAccountById(int id, int userId); // para el modify

    Task Delete(int id);
}

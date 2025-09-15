using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace wgud424_maui.Services
{
    public interface ILoginService
    {
        Task<bool> LoginAsync(string email, string password);
    }

    public class DatabaseLoginService : ILoginService
    {
        public Task<bool> LoginAsync(string email, string password)
        {
            return DatabaseHandler.LoginAsync(email, password);
        }
    }
}

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SwimmingApp.Abstract.Data
{
    public class UserLogin
    {
        public string Email { get; set;}
        public string Username { get; set;}
        public string Password { get; set;}
        public string SessionUuid{ get; set;}
    }
}

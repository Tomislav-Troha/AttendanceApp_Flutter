using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SwimmingApp.DAL.Responses
{
    public class UserLoginResponse : ResponseBase
    {
        public string Token { get; set; }
    }
}

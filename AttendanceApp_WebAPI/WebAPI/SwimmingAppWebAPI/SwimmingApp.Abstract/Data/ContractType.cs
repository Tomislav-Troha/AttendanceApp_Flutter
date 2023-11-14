using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SwimmingApp.Abstract.Data
{
    public class ContractType
    {
        public int ContractTypeID { get; set; }
        public string? ContractTypeName { get; set; }
        public string? ContractTypeDescription { get; set; }
    }
}

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SwimmingApp.Abstract.Data
{
    public class Attendance
    {
        public int ID_attendance { get; set; }
        public string AttDesc { get; set; }
        public string Type { get; set; }
        public int TrainingID { get; set; }
        public int UserID { get; set; }
        public int TrainingDateID { get; set; } 
    }
}

using SwimmingApp.Abstract.DataModel;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SwimmingApp.Abstract.DTO
{
    public class TrainingDTO : TrainingModel
    {
        public TrainingDTO(TrainingModel model)
        {
            ID_training = model.ID_training;
            Code = model.Code;
            TrainingType = model.TrainingType;
        }

        public TrainingDTO()
        {

        }
    }
}

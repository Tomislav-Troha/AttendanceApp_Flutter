using SwimmingApp.Abstract.Data;
using SwimmingApp.Abstract.DataModel;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SwimmingApp.Abstract.DTO
{
    public class TrainingDateDTO : TrainingDateModel
    {
        public TrainingDateDTO(TrainingDateModel model) 
        {
            ID_TrainingDate = model.ID_TrainingDate;
            Dates = model.Dates;
            TimeFrom = model.TimeFrom;
            TimeTo = model.TimeTo;
            UserModel = model.UserModel != null ? new UserDTO(model.UserModel) : null;
            TrainingModel = model.TrainingModel != null ? new TrainingDTO(model.TrainingModel) : null;
            UserRoleModel = model.UserRoleModel != null ? new UserRoleDTO(model.UserRoleModel) : null;


            if (model.UserModelList != null)
            {
                UserModelList = new List<UserModel>();
                foreach (var userModel in model.UserModelList)
                    UserModelList.Add(new UserModel(userModel));
            }

            //if (model.TrainingModelList != null)
            //{
            //    foreach (TrainingModel traModel in model.TrainingModelList)
            //    {
            //        TrainingModelList.Add(new TrainingModel(traModel));
            //    }
            //}
        }

        public TrainingDateDTO()
        {

        }
    }
}

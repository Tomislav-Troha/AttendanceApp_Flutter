using SwimmingApp.Abstract.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SwimmingApp.Abstract.DataModel
{
    public class TrainingDateModel : TrainingDate
    {
         public TrainingDateModel()
        {

        }

        public TrainingDateModel(TrainingDateModel model)
        {
            UserModel = new UserModel(model.UserModel);
            TrainingModel = new TrainingModel(model.TrainingModel);
            UserRoleModel = new UserRoleModel(model.UserRoleModel);

            if (model.UserModelList != null)
            {
                UserModelList = new List<UserModel>();
                foreach (var userModel in model.UserModelList)
                    UserModelList.Add(new UserModel(userModel));
            }

            //if (model.TrainingModelList != null)
            //{
            //    TrainingModelList = new List<TrainingModel>();
            //    foreach (var traModel in model.TrainingModelList)
            //        TrainingModelList.Add(new TrainingModel(traModel));
            //}
        }

        //public List<MemberModel> MemberModelList { get; set; }
        //public List<TrainingModel> TrainingModelList { get; set; }

        public UserModel UserModel { get; set; }
        public TrainingModel TrainingModel { get; set; }

        public UserRoleModel UserRoleModel { get; set; }

        public List<UserModel> UserModelList { get; set; }
    }
}

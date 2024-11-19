using SwimmingApp.Abstract.Data;

namespace SwimmingApp.Abstract.DataModel
{
    public class TrainingDateModel : TrainingDate
    {
        public TrainingDateModel()
        {
            
        }
        public TrainingDateModel(TrainingDateModel? model)
        {
            UserModel = new UserModel(model?.UserModel);
            TrainingModel = new TrainingModel(model?.TrainingModel);
            UserRoleModel = new UserRoleModel(model?.UserRoleModel);

            if (model?.UserModelList != null)
            {
                UserModelList = new List<UserModel>();
                foreach (var userModel in model.UserModelList)
                    UserModelList.Add(new UserModel(userModel));
            }
        }

        public UserModel? UserModel { get; set; }
        public TrainingModel? TrainingModel { get; set; }

        public UserRoleModel? UserRoleModel { get; set; }

        public List<UserModel>? UserModelList { get; set; }
    }
}

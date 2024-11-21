using SwimmingApp.Abstract.Data;

namespace SwimmingApp.Abstract.DataModel
{
    public class TrainingSessionModel : TrainingSession
    {
        public TrainingSessionModel()
        {
            
        }
        public TrainingSessionModel(TrainingSessionModel? model)
        {
            TrainerModel = new UserModel(model?.TrainerModel);
            TrainingModel = new TrainingModel(model?.TrainingModel);
            UserRoleModel = new UserRoleModel(model?.UserRoleModel);

            if (model?.UsersModel != null)
            {
                UsersModel = new List<UserModel>();
                foreach (var userModel in model.UsersModel)
                    UsersModel.Add(new UserModel(userModel));
            }
        }

        //Trainer is also a user
        public UserModel? TrainerModel { get; set; }
        public TrainingModel? TrainingModel { get; set; }
        public UserRoleModel? UserRoleModel { get; set; }
        public List<UserModel>? UsersModel { get; set; }
    }
}

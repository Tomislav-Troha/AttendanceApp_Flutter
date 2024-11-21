using SwimmingApp.Abstract.DataModel;

namespace SwimmingApp.Abstract.DTO
{
    public class TrainingSessionDTO : TrainingSessionModel
    {
        public TrainingSessionDTO()
        {

        }
        public TrainingSessionDTO(TrainingSessionModel model) : base(model)
        {
            ID = model.ID;
            TrainingModel = model.TrainingModel != null ? new TrainingDTO(model.TrainingModel) : null;
            TrainerModel = model.TrainerModel != null ? new UserDTO(model.TrainerModel) : null;
            UserRoleModel = model.UserRoleModel != null ? new UserRoleDTO(model.UserRoleModel) : null;

            if (model.UsersModel != null)
            {
                UsersModel = new List<UserModel>();
                foreach (var userModel in model.UsersModel)
                    UsersModel.Add(new UserModel(userModel));
            }
        }
    }
}

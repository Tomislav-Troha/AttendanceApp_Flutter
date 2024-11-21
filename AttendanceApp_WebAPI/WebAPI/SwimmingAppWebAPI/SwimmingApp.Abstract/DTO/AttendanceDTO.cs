using SwimmingApp.Abstract.DataModel;

namespace SwimmingApp.Abstract.DTO
{
    public class AttendanceDTO : AttendanceModel
    {
        public AttendanceDTO()
        {
            
        }
        public AttendanceDTO(AttendanceModel model) : base(model)
        {
            ID = model?.ID;
            UserModel = model?.UserModel != null ? new UserDTO(model.UserModel) : null;
            TrainingModel = model?.TrainingModel != null ? new TrainingDTO(model.TrainingModel) : null;
            TrainingSessionModel = model?.TrainingSessionModel != null ? new TrainingSessionDTO(model.TrainingSessionModel) : null;
            UserRoleModel = model?.UserRoleModel != null ? new UserRoleDTO(model.UserRoleModel) : null;
        }
    }
}

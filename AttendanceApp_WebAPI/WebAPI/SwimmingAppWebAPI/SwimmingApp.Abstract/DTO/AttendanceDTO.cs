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
            ID_attendance = model?.ID_attendance;
            AttDesc = model?.AttDesc;
            Type = model?.Type;
            UserModel = model?.UserModel != null ? new UserDTO(model.UserModel) : null;
            TrainingModel = model?.TrainingModel != null ? new TrainingDTO(model.TrainingModel) : null;
            TrainingDateModel = model?.TrainingDateModel != null ? new TrainingDateDTO(model.TrainingDateModel) : null;
            UserRoleModel = model?.UserRoleModel != null ? new UserRoleDTO(model.UserRoleModel) : null;
        }
    }
}

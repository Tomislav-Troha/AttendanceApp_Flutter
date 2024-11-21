using SwimmingApp.Abstract.Data;

namespace SwimmingApp.Abstract.DataModel
{
    public class AttendanceModel : Attendance
    {
        public AttendanceModel()
        {
            
        }
        public AttendanceModel(AttendanceModel model)
        {
            UserModel = new UserModel(model?.UserModel);
            TrainingModel = new TrainingModel(model?.TrainingModel);
            TrainingSessionModel = new TrainingSessionModel(model?.TrainingSessionModel);
            UserRoleModel = new UserRoleModel(model?.UserRoleModel);
        }

        public UserModel? UserModel { get; set; }
        public TrainingModel? TrainingModel { get; set; }
        public TrainingSessionModel? TrainingSessionModel { get; set; }

        public UserRoleModel? UserRoleModel { get; set; }
    }
}

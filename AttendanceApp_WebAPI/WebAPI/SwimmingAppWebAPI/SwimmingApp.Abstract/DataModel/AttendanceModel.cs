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
            TrainingDateModel = new TrainingDateModel(model?.TrainingDateModel);
            UserRoleModel = new UserRoleModel(model?.UserRoleModel);
        }

        public UserModel? UserModel { get; set; }
        public TrainingModel? TrainingModel { get; set; }
        public TrainingDateModel? TrainingDateModel { get; set; }

        public UserRoleModel? UserRoleModel { get; set; }
    }
}

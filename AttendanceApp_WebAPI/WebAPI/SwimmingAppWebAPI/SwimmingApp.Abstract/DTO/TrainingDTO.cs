using SwimmingApp.Abstract.DataModel;

namespace SwimmingApp.Abstract.DTO
{
    public class TrainingDTO : TrainingModel
    {
        public TrainingDTO(TrainingModel model) : base(model)
        {
            ID_training = model.ID_training;
            Code = model.Code;
            TrainingType = model.TrainingType;
        }
    }
}

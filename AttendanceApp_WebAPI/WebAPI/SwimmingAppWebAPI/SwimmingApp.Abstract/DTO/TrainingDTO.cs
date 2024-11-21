using SwimmingApp.Abstract.DataModel;

namespace SwimmingApp.Abstract.DTO
{
    public class TrainingDTO : TrainingModel
    {
        public TrainingDTO()
        {
            
        }
        public TrainingDTO(TrainingModel model) : base(model)
        {
            ID = model.ID;
            Code = model.Code;
            TrainingType = model.TrainingType;
            Title = model.Title;
            Description = model.Description;
        }
    }
}

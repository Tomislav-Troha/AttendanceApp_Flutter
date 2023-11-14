using Dapper;
using SwimmingApp.Abstract.DataModel;
using SwimmingApp.Abstract.DTO;
using SwimmingApp.DAL.Core;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SwimmingApp.DAL.Repositories.TrainingService
{
    public class TrainingService : ITrainingService
    {
        private readonly IDbService _db;
        public TrainingService(IDbService dbService)
        {
            _db = dbService;
        }
        public async Task DeleteTraining(int id)
        {
            DynamicParameters param = new DynamicParameters();
            param.Add("id", id);

            await _db.DeleteAsync("CALL Training_Delete(@id)", param);
        }

        public async Task<IEnumerable<TrainingModel>> GetTraining(int? id)
        {
            DynamicParameters param = new DynamicParameters();
            param.Add("id", id);

            return await _db.GetAsync<TrainingModel>("SELECT * FROM Training_Select(@id)", param);  
        }

        public async Task<TrainingDTO> InsertTraining(TrainingDTO trainingDTO)
        {
            DynamicParameters param = new DynamicParameters();
            param.Add("code", trainingDTO.Code);
            param.Add("trainingType", trainingDTO.TrainingType);

            await _db.InsertAsync("CALL Training_Insert(@code, @trainingType)", param);

            return trainingDTO;
        }

        public async Task<TrainingDTO> UpdateTraining(TrainingDTO trainingDTO)
        {
            DynamicParameters param = new DynamicParameters();
            param.Add("id", trainingDTO.ID_training);
            param.Add("code", trainingDTO.Code);
            param.Add("trainingType", trainingDTO.TrainingType);

            await _db.UpdateAsync("CALL Training_Update(@id, @code, @trainingType)", param);

            return trainingDTO;
        }
    }
}

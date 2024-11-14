using Dapper;
using SwimmingApp.Abstract.DataModel;
using SwimmingApp.Abstract.DTO;
using SwimmingApp.DAL.Contex;
using SwimmingApp.DAL.Core;

namespace SwimmingApp.DAL.Repositories.EmployeeContract
{
    public class ContractService : IContractService
    {

        private readonly IDbService _db;
        private readonly DapperContext _context;
        public ContractService(IDbService db, DapperContext context)
        {
            _db = db;
            _context = context;
        }

        public async Task<IEnumerable<ContractModel>?> GetContracts(int? userId)
        {
            DynamicParameters param = new DynamicParameters();
            param.Add("userId", userId);

            var query = "SELECT * FROM Contract_SelectByUserId(@userId)";
            using var connection = _context.CreateConnection();

            IEnumerable<ContractModel> employeeContracts = await connection.QueryAsync<ContractModel,
                UserModel,
                UserRoleModel,
                ContractTypeModel,
                SalaryPackageTypeModel,
                JobRoleModel,
                ContractModel>(query,
                (employeeContract, user, userRole, contractType, salaryPackage, jobRole) =>
                {
                    employeeContract.UserModel = user;
                    employeeContract.UserRoleModel = userRole;
                    employeeContract.ContractTypeModel = contractType;
                    employeeContract.SalaryPackageTypeModel = salaryPackage;
                    employeeContract.JobRoleModel = jobRole;
                    return employeeContract;
                }, param, splitOn: "userId, roleId, contractTypeId, salaryPackageId, jobRoleId");

            return employeeContracts;
        }

        public async Task<ContractDTO?> InsertContract(ContractDTO? memberContractDTO, int? userID)
        {
            DynamicParameters param = new DynamicParameters();
            param.Add("userID", userID);
            param.Add("userRoleID", memberContractDTO?.UserRoleModel?.RoleId);
            param.Add("contractTypeID", memberContractDTO?.ContractTypeModel?.ContractTypeID != 0 ? memberContractDTO?.ContractTypeModel?.ContractTypeID : null);
            param.Add("salaryPackageID", memberContractDTO?.SalaryPackageTypeModel?.SalaryPackageID != 0 ? memberContractDTO?.SalaryPackageTypeModel?.SalaryPackageID : null);
            param.Add("jobRoleID", memberContractDTO?.JobRoleModel?.JobRoleID != 0 ? memberContractDTO?.JobRoleModel?.JobRoleID : null);
            param.Add("startDate", memberContractDTO?.StartDate);
            param.Add("expiryDate", memberContractDTO?.ExpiryDate);

            await _db.InsertAsync("CALL Contract_Insert(@userID, @userRoleID, @contractTypeID, @salaryPackageID, @jobRoleID, @startDate, @expiryDate)", param);

            return memberContractDTO;
        }

        public async Task<ContractDTO?> UpdateContract(ContractDTO? memberContractDTO)
        {
            DynamicParameters param = new DynamicParameters();
            param.Add("id", memberContractDTO?.ContractID);
            param.Add("contractTypeID", memberContractDTO?.ContractTypeModel?.ContractTypeID);
            param.Add("salaryPackageID", memberContractDTO?.SalaryPackageTypeModel?.SalaryPackageID);
            param.Add("jobRoleID", memberContractDTO?.JobRoleModel?.JobRoleID);
            param.Add("startDate", memberContractDTO?.StartDate);
            param.Add("expiryDate", memberContractDTO?.ExpiryDate);

            await _db.UpdateAsync("CALL Contract_Update(@id, @contractTypeID, @salaryPackageID, @jobRoleID, @startDate, @expiryDate)", param);

            return memberContractDTO;
        }
    }
}

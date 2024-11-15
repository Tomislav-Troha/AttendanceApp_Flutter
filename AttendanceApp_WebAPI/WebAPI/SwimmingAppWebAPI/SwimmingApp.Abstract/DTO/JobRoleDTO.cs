﻿using SwimmingApp.Abstract.DataModel;

namespace SwimmingApp.Abstract.DTO
{
    public class JobRoleDTO : JobRoleModel
    {
        public JobRoleDTO(JobRoleModel model) : base(model)
        {
            JobRoleID = model.JobRoleID;
            JobRoleName = model.JobRoleName;
            JobRoleDescription = model.JobRoleDescription;
        }
    }
}
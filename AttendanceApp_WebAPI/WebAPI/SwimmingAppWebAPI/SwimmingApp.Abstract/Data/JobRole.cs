using System.ComponentModel.DataAnnotations.Schema;

namespace SwimmingApp.Abstract.Data
{
    public class JobRole
    {
        [Column("JobRoleID")]
        public int? ID { get; set; }

        [Column("JobRoleName")]
        public string? Name { get; set; }

        [Column("JobRoleDescription")]
        public string? Description { get; set; }
    }
}

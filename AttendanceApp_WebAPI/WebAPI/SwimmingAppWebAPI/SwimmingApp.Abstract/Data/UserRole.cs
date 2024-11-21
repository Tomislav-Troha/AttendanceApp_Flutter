using System.ComponentModel.DataAnnotations.Schema;

namespace SwimmingApp.Abstract.Data
{
    public class UserRole
    {
        [Column("UserRoleID")]
        public int? ID { get; set; }

        [Column("UserRoleName")]
        public string? Name { get; set; }

        [Column("UserRoleDescription")]
        public string? Description { get; set; }
    }
}

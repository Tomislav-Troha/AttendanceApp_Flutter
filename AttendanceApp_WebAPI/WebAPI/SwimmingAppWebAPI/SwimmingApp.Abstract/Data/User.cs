using System.ComponentModel.DataAnnotations.Schema;

namespace SwimmingApp.Abstract.Data
{
    public class User
    {
        [Column("UserID")]
        public int? ID { get; set; }
        public string? Name { get; set; }
        public string? Surname { get; set; }
        public string? Email { get; set; }
        public string? Username { get; set; }
        public byte[]? Password { get; set; }
        public byte[]? Salt { get; set; }
        public string? Address { get; set; }
        public int? UserRoleID { get; set; }
        public byte[]? ProfileImage { get; set; }
    }
}

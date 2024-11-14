using System.Security.Cryptography;
using System.Text;

namespace SwimmingApp.BL.Utils
{
    public class PasswordManager
    {
        public byte[] GeneratePasswordHash(string? password, byte[] salt)
        {
            var sha256 = SHA256.Create();
            return sha256.ComputeHash(Encoding.UTF8.GetBytes(password + salt));
        }

        public byte[] GenerateSaltHash()
        {
            var sha256 = SHA256.Create();
            return sha256.ComputeHash(Encoding.UTF8.GetBytes(Guid.NewGuid().ToString()));
        }

        public byte[] GenerateActivationToken()
        {
            var sha256 = SHA256.Create();
            return sha256.ComputeHash(Encoding.UTF8.GetBytes(Guid.NewGuid().ToString()));
        }
    }
}

using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using Microsoft.Extensions.Configuration;
using Microsoft.IdentityModel.Tokens;
using SwimmingApp.Abstract.DataModel;

namespace SwimmingApp.BL.Utils
{
    public class TokenGenerator
    {
        public static string CreateToken(UserModel user, IConfiguration configuration)
        {
            List<Claim> claims = new List<Claim>
            {
                new Claim("FirstLastName", $"{user.Name} {user.Surname}"),
                new Claim("UserRoleId", user?.UserRoleModel?.RoleId?.ToString()!),
                new Claim("UserID", user?.UserId?.ToString()!)
            };

            var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(configuration.GetSection("AppSettings:Token").Value));
            var cred = new SigningCredentials(key, SecurityAlgorithms.HmacSha512Signature);

            var token = new JwtSecurityToken(
                claims: claims,
                expires: DateTime.Now.AddHours(2),
                signingCredentials: cred
                );

            var jwt = new JwtSecurityTokenHandler().WriteToken(token);

            return jwt;
        }
    }
}

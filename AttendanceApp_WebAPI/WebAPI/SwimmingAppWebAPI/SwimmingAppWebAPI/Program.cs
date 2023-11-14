using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.IdentityModel.Tokens;
using Microsoft.OpenApi.Models;
using SwimmingApp.Abstract.Data;
using SwimmingApp.BL.Managers.AttendanceManager;
using SwimmingApp.BL.Managers.ChangePasswordManager;
using SwimmingApp.BL.Managers.ContractTypeManager;
using SwimmingApp.BL.Managers.EmployeeContractManager;
using SwimmingApp.BL.Managers.JobRoleManager;
using SwimmingApp.BL.Managers.Log;
using SwimmingApp.BL.Managers.SalaryPackageTypeManager;
using SwimmingApp.BL.Managers.TrainingDateManager;
using SwimmingApp.BL.Managers.TrainingManager;
using SwimmingApp.BL.Managers.UserLoginManager;
using SwimmingApp.BL.Managers.UserManager;
using SwimmingApp.BL.Managers.UserRegisterManager;
using SwimmingApp.DAL.Contex;
using SwimmingApp.DAL.Core;
using SwimmingApp.DAL.Repositories.AttendanceService;
using SwimmingApp.DAL.Repositories.ContractTypeService;
using SwimmingApp.DAL.Repositories.EmployeeContract;
using SwimmingApp.DAL.Repositories.JobRoleService;
using SwimmingApp.DAL.Repositories.Log;
using SwimmingApp.DAL.Repositories.PaswordResetService;
using SwimmingApp.DAL.Repositories.SalaryPackageTypeService;
using SwimmingApp.DAL.Repositories.TrainingDateService;
using SwimmingApp.DAL.Repositories.TrainingService;
using SwimmingApp.DAL.Repositories.UserLoginService;
using SwimmingApp.DAL.Repositories.UserRegisterService;
using SwimmingApp.DAL.Repositories.UserService;
using SwimmingApp.DAL.Utils;
using System.Text;

internal class Program
{

    public void ConfigureServices(IServiceCollection services) { }
    private static void Main(string[] args)
    {
        var builder = WebApplication.CreateBuilder(args);

        // Add services to the container
        var services = builder.Services;

        services.AddControllers();

        services.AddEndpointsApiExplorer();

        services.AddSwaggerGen(options =>
        {
            options.AddSecurityDefinition("oauth2", new OpenApiSecurityScheme
            {
                Description = "Standard Authorization header using the Bearer scheme",
                In = ParameterLocation.Header,
                Name = "Authorization",
                Type = SecuritySchemeType.ApiKey
            });
            options.OperationFilter<ReApplyOptionalRouteParameterOperationFilter>();

            options.AddSecurityRequirement(new OpenApiSecurityRequirement
                {
                    {
                        new OpenApiSecurityScheme
                        {
                            Reference = new OpenApiReference
                            {
                                Type = ReferenceType.SecurityScheme, // or ReferenceType.Parameter
                                Id = "oauth2"
                            }
                        },
                        new string[] {}
                    }
                });
        });

        services.AddAuthentication(options =>
        {
            options.DefaultScheme = JwtBearerDefaults.AuthenticationScheme;
            options.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;
            options.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
        })
             .AddJwtBearer(options =>
             {
                 options.TokenValidationParameters = new TokenValidationParameters
                 {
                     ValidateIssuerSigningKey = true,
                     IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(builder.Configuration["AppSettings:Token"])),
                     ValidateIssuer = false,
                     ValidateAudience = false
                 };
             });


        #region Controllers

        services.AddControllers();

        services.AddSingleton<DapperContext>();

        services.AddScoped<IDbService, DbService>();

        services.AddScoped<IUserService, UserService>();
        services.AddTransient<UserManager>();

        services.AddScoped<IUserRegisterService, UserRegisterService>();
        services.AddTransient<UserRegisterManager>();

        services.AddScoped<IUserLoginService, UserLoginService>();
        services.AddTransient<UserLoginManager>();

        services.AddScoped<ITrainingService, TrainingService>();
        services.AddTransient<TrainingManager>();

        services.AddScoped<IAttendanceService, AttendanceService>();
        services.AddTransient<AttendanceManager>();

        services.AddScoped<ITrainingDateService, TrainingDateService>();
        services.AddTransient<TrainingDateManager>();

        services.AddScoped<IPasswordResetService, PasswordResetService>();
        services.AddTransient<PasswordResetManager>();

        services.AddScoped<IErrorLogService, ErrorLogService>();
        services.AddTransient<ErrorLogsManager>();

        services.AddScoped<IContractService, ContractService>();
        services.AddTransient<ContractManager>();

        services.AddScoped<IJobRoleService, JobRoleService>();
        services.AddTransient<JobRoleManager>();

        services.AddScoped<IContractTypeService, ContractTypeService>();
        services.AddTransient<ContractTypeManager>();

        services.AddScoped<ISalaryPackageTypeService, SalaryPackageTypeService>();
        services.AddTransient<SalaryPackageTypeManager>();

        #endregion

        services.AddCors(p => p.AddPolicy("corsapp", builder =>
        {
            builder.WithOrigins("*").AllowAnyOrigin().AllowAnyHeader().AllowAnyMethod();
        }));

        var app = builder.Build();


        if (app.Environment.IsDevelopment())
        {
            app.UseSwagger();
            app.UseSwaggerUI(c =>
            {
                c.RoutePrefix = string.Empty;
                c.SwaggerEndpoint("/swagger/v1/swagger.json", "WebAPI(v1)");
            });
        }

        app.UseHttpsRedirection();

        app.UseAuthentication();

        app.UseAuthorization();

        app.UseCors("corsapp");

        app.MapControllers();

        app.Run();

    }
}

using System.Reflection;
using System.Text;

namespace SwimmingApp.DAL.Helper
{
    public class ExceptionHelper
    {
        public static string GetMethodSignature(Exception e)
        {
            if (e.TargetSite == null)
            {
                return string.Empty;
            }

            string methodName = $"{e.TargetSite?.DeclaringType?.FullName}.{e.TargetSite?.Name}";

            ParameterInfo[]? paramsInfo = e.TargetSite?.GetParameters();

            if (paramsInfo != null && paramsInfo.Length > 0)
            {
                StringBuilder parameters = new StringBuilder();

                foreach (var param in paramsInfo)
                {
                    if (parameters.Length > 0)
                    {
                        parameters.Append(", ");
                    }
                    parameters.Append($"{param.ParameterType.Name} {param.Name}");
                }

                return $"{methodName}({parameters})";
            }
            else
            {
                return $"{methodName}()";
            }
        }

    }
}

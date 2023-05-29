using Microsoft.AspNetCore.Http;
using System.Security.Claims;

namespace Common.Helpers;

public interface IUserAccessor { ClaimsPrincipal User { get; } string SubjectId { get; } }

public class UserAccessor : IUserAccessor
{
  private readonly IHttpContextAccessor _accessor;

  public UserAccessor(IHttpContextAccessor accessor)
  {
    _accessor = accessor ?? throw new ArgumentNullException(nameof(accessor));
  }

  public ClaimsPrincipal User => _accessor.HttpContext.User;
  public string SubjectId => User.FindFirst(ClaimTypes.NameIdentifier).Value;
}
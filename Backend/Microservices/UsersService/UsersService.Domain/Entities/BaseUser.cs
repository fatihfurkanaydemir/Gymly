namespace UsersService.Domain.Entities;

using Common.Entities;
using UsersService.Domain.Enums;

public class BaseUser : AuditableBaseEntity
{
  public string SubjectId { get; set; } = default!;
  public double Weight { get; set; } = default!;
  public double Height { get; set; } = default!;
  public string Gender { get; set; } = default!;
  public UserType Type { get; set; } = UserType.Normal;
}

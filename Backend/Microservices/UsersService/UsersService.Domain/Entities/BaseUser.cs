namespace UsersService.Domain.Entities;

using Common.Entities;
using UsersService.Domain.Enums;

public class BaseUser : AuditableBaseEntity
{
  public virtual string SubjectId { get; set; } = default!;
  public virtual double Weight { get; set; } = default!;
  public virtual double Height { get; set; } = default!;
  public virtual string Gender { get; set; } = default!;
  public virtual UserType Type { get; set; } = UserType.Normal;
}

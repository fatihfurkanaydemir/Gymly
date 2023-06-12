using Common.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace UsersService.Domain.Entities;

public class Workout : AuditableBaseEntity
{
  public string SubjectId { get; set; } = default!;
  public int DurationInMinutes { get; set; } = default!;
  public string ProgramTitle { get; set; } = default!;
  public string ProgramDescription { get; set; } = default!;
  public string ProgramContent { get; set; } = default!;
}

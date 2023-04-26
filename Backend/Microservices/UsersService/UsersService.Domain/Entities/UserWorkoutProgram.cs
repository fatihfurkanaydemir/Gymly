using Common.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace UsersService.Domain.Entities;

public class UserWorkoutProgram : AuditableBaseEntity
{
  public string Title { get; set; } = default!;
  public string Description { get; set; } = default!;
  public string Content { get; set; } = default!;
}

using Common.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace UsersService.Domain.Entities;

public class TrainerWorkoutProgram : AuditableBaseEntity
{
  public string Name { get; set; } = default!;
  public string Title { get; set; } = default!;
  public string Description { get; set; } = default!;
  public string HeaderImageUrl { get; set; } = default!;
  public string ProgramDetails { get; set; } = default!;
}

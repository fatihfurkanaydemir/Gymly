using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace UsersService.Domain.Entities;

public class User : BaseUser
{
  public virtual List<UserWorkoutProgram> UserWorkoutPrograms { get; set; } = new List<UserWorkoutProgram>();
  public virtual string Diet { get; set; } = default!;
  public virtual List<TrainerWorkoutProgram> TrainerWorkoutPrograms { get; set; } = new List<TrainerWorkoutProgram>();
  public virtual TrainerWorkoutProgram? EnrolledProgram { get; set; }
}

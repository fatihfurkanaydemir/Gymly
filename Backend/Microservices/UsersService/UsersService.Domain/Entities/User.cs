using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace UsersService.Domain.Entities;

public class User : BaseUser
{
  public List<UserWorkoutProgram> UserWorkoutPrograms { get; set; } = new List<UserWorkoutProgram>();
  public string Diet { get; set; } = default!;
  // IF SWITCHED TO TRAINER ACCOUNT
  public List<TrainerWorkoutProgram> TrainerWorkoutPrograms { get; set; } = new List<TrainerWorkoutProgram>();
}

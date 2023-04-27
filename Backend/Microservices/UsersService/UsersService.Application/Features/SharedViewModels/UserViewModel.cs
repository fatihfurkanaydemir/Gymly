using UsersService.Domain.Entities;
using UsersService.Domain.Enums;

namespace UsersService.Application.Features.SharedViewModels;

public class UserViewModel
{
  public int Id { get; set; }
  public double Weight { get; set; } = default!;
  public double Height { get; set; } = default!;
  public string Gender { get; set; } = default!;
  public List<UserWorkoutProgram> UserWorkoutPrograms { get; set; } = default!;
  public List<UserWorkoutProgram> TrainerWorkoutPrograms { get; set; } = default!;
  public string Diet { get; set; } = default!;
  public UserType Type { get; set; } = default!;
}

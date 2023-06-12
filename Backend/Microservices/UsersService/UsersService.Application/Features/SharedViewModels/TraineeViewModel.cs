using UsersService.Domain.Entities;
using UsersService.Domain.Enums;

namespace UsersService.Application.Features.SharedViewModels;

public class TraineeViewModel
{
  public int Id { get; set; }
  public string SubjectId { get; set; } = default!;
  public double Weight { get; set; } = default!;
  public double Height { get; set; } = default!;
  public string Gender { get; set; } = default!;
  public string Diet { get; set; } = default!;
  public string FirstName { get; set; } = default!;
  public string LastName { get; set; } = default!;
  public string AvatarUrl { get; set; } = default!;
  public TrainerWorkoutProgramViewModel EnrolledProgram { get; set; } = default!;
}

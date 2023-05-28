using UsersService.Domain.Entities;
using UsersService.Domain.Enums;

namespace UsersService.Application.Features.SharedViewModels;

public class TrainerWorkoutProgramViewModel
{
  public virtual int Id { get; set; }
  public DateTime Created { get; set; }
  public DateTime LastModified { get; set; }
  public string Name { get; set; } = default!;
  public double Price { get; set; } = default!;
  public string Title { get; set; } = default!;
  public string Description { get; set; } = default!;
  public string HeaderImageUrl { get; set; } = default!;
  public string ProgramDetails { get; set; } = default!;
}

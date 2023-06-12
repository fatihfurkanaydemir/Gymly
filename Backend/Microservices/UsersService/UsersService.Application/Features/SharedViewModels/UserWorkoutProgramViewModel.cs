using UsersService.Domain.Entities;
using UsersService.Domain.Enums;

namespace UsersService.Application.Features.SharedViewModels;

public class UserWorkoutProgramViewModel
{
  public virtual int Id { get; set; }
  public DateTime Created { get; set; }
  public DateTime LastModified { get; set; }
  public string Title { get; set; } = default!;
  public string Description { get; set; } = default!;
  public string Content { get; set; } = default!;
}

namespace UsersService.Infrastructure.Persistence.Repositories;

using UsersService.Application.Interfaces.Repositories;
using UsersService.Domain.Entities;
using UsersService.Infrastructure.Persistence.Contexts;
using Microsoft.EntityFrameworkCore;

public class UserWorkoutProgramRepositoryAsync: GenericRepositoryAsync<UserWorkoutProgram>, IUserWorkoutProgramRepositoryAsync
{
  private readonly DbSet<UserWorkoutProgram> _userWorkoutPrograms;

  public UserWorkoutProgramRepositoryAsync(UsersServiceDbContext dbContext) : base(dbContext)
  {
    _userWorkoutPrograms = dbContext.UserWorkoutPrograms;
  }
}

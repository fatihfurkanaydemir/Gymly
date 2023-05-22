namespace UsersService.Infrastructure.Persistence.Repositories;

using UsersService.Application.Interfaces.Repositories;
using UsersService.Domain.Entities;
using UsersService.Infrastructure.Persistence.Contexts;
using Microsoft.EntityFrameworkCore;

public class UserRepositoryAsync: GenericRepositoryAsync<User>, IUserRepositoryAsync
{
  private readonly DbSet<User> _Users;

  public UserRepositoryAsync(UsersServiceDbContext dbContext) : base(dbContext)
  {
    _Users = dbContext.Users;
  }

  public async Task<User?> GetBySubjectIdAsync(String subjectId)
  {
    return await
      _Users
      .Where(x => x.SubjectId == subjectId)
      .Include(x => x.UserWorkoutPrograms)
      .Include(x => x.TrainerWorkoutPrograms)
      .AsNoTracking()
      .FirstOrDefaultAsync();
  }

  public async Task<User?> GetBySubjectIdMinAsync(String subjectId)
  {
    return await
      _Users
      .Where(x => x.SubjectId == subjectId)
      .AsNoTracking()
      .FirstOrDefaultAsync();
  }
}

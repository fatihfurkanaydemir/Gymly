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
      .Include(x => x.EnrolledProgram)
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

  public async Task<IReadOnlyList<User>> GetTrainersPagedAsync(int pageNumber, int pageSize)
  {
    return await _Users
        .Where(u => u.Type == Domain.Enums.UserType.Trainer)
        .Skip((pageNumber - 1) * pageSize)
        .Take(pageSize)
        .AsNoTracking()
        .ToListAsync();
  }

  public async Task<User?> GetTrainerBySubjectIdAsync(string subjectId)
  {
    return await
      _Users
      .Where(x => x.SubjectId == subjectId && x.Type == Domain.Enums.UserType.Trainer)
      .Include(x => x.TrainerWorkoutPrograms)
      .AsNoTracking()
      .FirstOrDefaultAsync();
  }

  public async Task<int> GetTrainerDataCount()
  {
    return await _Users
      .Where(u => u.Type == Domain.Enums.UserType.Trainer)
      .CountAsync();
  }
}

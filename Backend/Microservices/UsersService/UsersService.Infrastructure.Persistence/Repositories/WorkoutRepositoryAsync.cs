namespace UsersService.Infrastructure.Persistence.Repositories;

using UsersService.Application.Interfaces.Repositories;
using UsersService.Domain.Entities;
using UsersService.Infrastructure.Persistence.Contexts;
using Microsoft.EntityFrameworkCore;

public class WorkoutRepositoryAsync : GenericRepositoryAsync<Workout>, IWorkoutRepositoryAsync
{
  private readonly DbSet<Workout> _Workouts;

  public WorkoutRepositoryAsync(UsersServiceDbContext dbContext) : base(dbContext)
  {
    _Workouts = dbContext.Workouts;
  }

  public async Task<List<Workout>> GetBySubjectIdPagedAsync(string subjectId, int pageSize, int pageNumber)
  {
    return await
      _Workouts
      .Where(x => x.SubjectId == subjectId)
      .Skip((pageNumber - 1) * pageSize)
      .Take(pageSize)
      .OrderByDescending(x => x.Created)
      .AsNoTracking()
      .ToListAsync();
  }

  public async Task<int> GetDataCountBySubjectId(string subjectId)
  {
    return await
      _Workouts
      .Where(x => x.SubjectId == subjectId)
      .CountAsync();
  }
}

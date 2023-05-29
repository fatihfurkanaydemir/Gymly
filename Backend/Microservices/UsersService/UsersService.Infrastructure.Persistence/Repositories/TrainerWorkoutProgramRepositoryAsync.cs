namespace UsersService.Infrastructure.Persistence.Repositories;

using UsersService.Application.Interfaces.Repositories;
using UsersService.Domain.Entities;
using UsersService.Infrastructure.Persistence.Contexts;
using Microsoft.EntityFrameworkCore;

public class TrainerWorkoutProgramRepositoryAsync: GenericRepositoryAsync<TrainerWorkoutProgram>, ITrainerWorkoutProgramRepositoryAsync
{
  private readonly DbSet<TrainerWorkoutProgram> _trainerWorkoutPrograms;

  public TrainerWorkoutProgramRepositoryAsync(UsersServiceDbContext dbContext) : base(dbContext)
  {
    _trainerWorkoutPrograms = dbContext.TrainerWorkoutPrograms;
  }

  public async Task<TrainerWorkoutProgram?> getByIdWithRelationsAsync(int id)
  {
    return await _trainerWorkoutPrograms
      .Include(p => p.EnrolledUsers)
      .FirstOrDefaultAsync(p => p.Id == id);
  }
}

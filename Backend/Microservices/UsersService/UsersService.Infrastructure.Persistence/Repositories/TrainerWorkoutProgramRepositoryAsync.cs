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
}

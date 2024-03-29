﻿namespace UsersService.Application.Interfaces.Repositories;

using UsersService.Domain.Entities;

public interface ITrainerWorkoutProgramRepositoryAsync : IGenericRepositoryAsync<TrainerWorkoutProgram>
{
  Task<TrainerWorkoutProgram?> getByIdWithRelationsAsync(int id);
}

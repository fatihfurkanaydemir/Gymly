namespace UsersService.Application.Interfaces.Repositories;

using UsersService.Domain.Entities;

public interface IWorkoutRepositoryAsync : IGenericRepositoryAsync<Workout>
{
  Task<List<Workout>> GetBySubjectIdPagedAsync(string subjectId, int pageSize, int pageNumber);
  Task<int> GetDataCountBySubjectId(string subjectId);
}

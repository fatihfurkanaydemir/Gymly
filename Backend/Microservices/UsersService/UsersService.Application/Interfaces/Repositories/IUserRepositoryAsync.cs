namespace UsersService.Application.Interfaces.Repositories;

using UsersService.Domain.Entities;

public interface IUserRepositoryAsync: IGenericRepositoryAsync<User>
{
  Task<User?> GetBySubjectIdAsync(String subjectId);
  Task<User?> GetBySubjectIdMinAsync(String subjectId);
  Task<IReadOnlyList<User>> GetTrainersPagedAsync(int pageNumber, int pageSize);
  Task<User?> GetTrainerBySubjectIdAsync(string subjectId);
  Task<int> GetTrainerDataCount();
}

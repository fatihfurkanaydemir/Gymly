namespace UsersService.Application.Interfaces.Repositories;

using UsersService.Domain.Entities;

public interface IUserRepositoryAsync: IGenericRepositoryAsync<User>
{
  Task<User?> GetBySubjectIdAsync(String subjectId);
}

using PostService.Domain.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PostService.Application.Interfaces.Repositories;

public interface IPostRepository
{
  public Task<IReadOnlyList<Post>> GetPagedReponseAsync(string subjectId, int pageNumber, int pageSize);
  Task<IReadOnlyList<Post>> GetPagedReponseBySubjectIdAsync(string subjectId, int pageNumber, int pageSize);
  public Task<int> GetDataCount();
  Task<int> GetDataCountBySubjectId(string subjectId);
  public Task<Post> GetByIdAsync(string id);
  public Task AddAsync(Post post);
  public Task RemoveAsync(string id);
  public Task UpdateAsync(string id, Post post);
}

using PostService.Domain.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PostService.Application.Interfaces.Repositories;

public interface IPostRepository
{
  public Task<IReadOnlyList<Post>> GetPagedReponseAsync(int pageNumber, int pageSize);
  public Task<int> GetDataCount();
  public Task<Post> GetByIdAsync(string id);
  public Task AddAsync(Post post);
  public Task RemoveAsync(string id);
  public Task UpdateAsync(string id, Post post);
}

using MongoDB.Driver;
using PostService.Application.Interfaces.Repositories;
using PostService.Domain.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PostService.Infrastructure.Persistence.Repositories;

public class PostRepository : IPostRepository
{
  private readonly IMongoCollection<Post> collection;

  public PostRepository(IMongoCollection<Post> collection)
  {
    this.collection = collection;
  }

  public async Task<IReadOnlyList<Post>> GetPagedReponseAsync(int pageNumber, int pageSize)
  {
    return await collection
        .Find(x => true)
        .SortByDescending(x => x.CreateDate)
        .Skip((pageNumber - 1) * pageSize)
        .Limit(pageSize)
        .ToListAsync();
  }

  public async Task<int> GetDataCount()
  {
    return (int)(await collection.CountDocumentsAsync(x => true));
  }

  public async Task<Post> GetByIdAsync(string id) 
  {
    return await collection.Find(x => x.Id == id).FirstOrDefaultAsync();
  }

  public async Task AddAsync(Post post)
  {
    await collection.InsertOneAsync(post);
  }

  public async Task RemoveAsync(string id)
  {
    await collection.DeleteOneAsync(x => x.Id == id);
  }

  public async Task UpdateAsync(string id, Post post)
  {
    await collection.ReplaceOneAsync(x => x.Id == id, post);
  }
}

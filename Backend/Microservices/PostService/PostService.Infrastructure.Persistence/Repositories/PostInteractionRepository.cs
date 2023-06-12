using MongoDB.Driver;
using PostService.Application.Interfaces.Repositories;
using PostService.Domain.Entities;

namespace PostService.Infrastructure.Persistence.Repositories;

public class PostInteractionRepository : IPostInteractionRepository
{
  private readonly IMongoCollection<PostInteraction> collection;

  public PostInteractionRepository(IMongoCollection<PostInteraction> collection)
  {
    this.collection = collection;
  }

  public async Task<IReadOnlyList<PostInteraction>> GetInteractionsOfUser(string subjectId)
  {
    return await collection
        .Find(x => x.SubjectId == subjectId)
        .ToListAsync();
  }

  public async Task<PostInteraction> GetByPostAndSubjectIdAsync(string postId, string subjectId)
  {
    return await collection.Find(x => x.SubjectId == subjectId && x.PostId == postId).FirstOrDefaultAsync();
  }

  public async Task RemoveAllInteractionsOfPostAsync(string postId)
  {
    await collection.DeleteManyAsync(x => x.PostId == postId);
  }

  public async Task<PostInteraction> GetByIdAsync(string id) 
  {
    return await collection.Find(x => x.Id == id).FirstOrDefaultAsync();
  }

  public async Task AddAsync(PostInteraction post)
  {
    await collection.InsertOneAsync(post);
  }

  public async Task RemoveAsync(string id)
  {
    await collection.DeleteOneAsync(x => x.Id == id);
  }

  public async Task UpdateAsync(string id, PostInteraction post)
  {
    await collection.ReplaceOneAsync(x => x.Id == id, post);
  }
}

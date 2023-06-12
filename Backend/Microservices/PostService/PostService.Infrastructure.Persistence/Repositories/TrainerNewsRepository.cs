using MongoDB.Driver;
using PostService.Application.Interfaces.Repositories;
using PostService.Domain.Entities;

namespace PostService.Infrastructure.Persistence.Repositories;

public class TrainerNewsRepository : ITrainerNewsRepository
{
  private readonly IMongoCollection<TrainerNews> collection;

  public TrainerNewsRepository(IMongoCollection<TrainerNews> collection)
  {
    this.collection = collection;
  }

  public async Task<IReadOnlyList<TrainerNews>> GetPagedReponseBySubjectIdAsync(string subjectId, int pageNumber, int pageSize)
  {
    return await collection
        .Find(x => x.SubjectId == subjectId)
        .SortByDescending(x => x.CreateDate)
        .Skip((pageNumber - 1) * pageSize)
        .Limit(pageSize)
        .ToListAsync();
  }

  public async Task<int> GetDataCountBySubjectId(string subjectId)
  {
    return (int)(await collection.CountDocumentsAsync(x => x.SubjectId == subjectId));
  }

  public async Task<TrainerNews> GetByIdAsync(string id) 
  {
    return await collection.Find(x => x.Id == id).FirstOrDefaultAsync();
  }

  public async Task AddAsync(TrainerNews TrainerNews)
  {
    await collection.InsertOneAsync(TrainerNews);
  }

  public async Task RemoveAsync(string id)
  {
    await collection.DeleteOneAsync(x => x.Id == id);
  }

  public async Task UpdateAsync(string id, TrainerNews TrainerNews)
  {
    await collection.ReplaceOneAsync(x => x.Id == id, TrainerNews);
  }
}

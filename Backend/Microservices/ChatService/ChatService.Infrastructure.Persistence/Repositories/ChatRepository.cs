using MongoDB.Driver;
using ChatService.Application.Interfaces.Repositories;
using ChatService.Domain.Entities;

namespace ChatService.Infrastructure.Persistence.Repositories;

public class ChatRepository : IChatRepository
{
  private readonly IMongoCollection<ChatMessage> collection;

  public ChatRepository(IMongoCollection<ChatMessage> collection)
  {
    this.collection = collection;
  }

  public async Task<IReadOnlyList<ChatMessage>> GetPagedReponseAsync(string senderId, string receiverId, int pageNumber, int pageSize)
  {
    return await collection
        .Find(x => (x.SenderId == senderId && x.ReceiverId == receiverId) || (x.SenderId == receiverId && x.ReceiverId == senderId))
        .SortByDescending(x => x.MessageTime)
        .Skip((pageNumber - 1) * pageSize)
        .Limit(pageSize)
        .ToListAsync();
  }

  public async Task<int> GetDataCount(string senderId, string receiverId)
  {
    return (int)(await collection.CountDocumentsAsync(x => (x.SenderId == senderId && x.ReceiverId == receiverId) || (x.SenderId == receiverId && x.ReceiverId == senderId)));
  }

  public async Task<ChatMessage> GetByIdAsync(string id)
  {
    return await collection.Find(x => x.Id == id).FirstOrDefaultAsync();
  }

  public async Task AddAsync(ChatMessage post)
  {
    await collection.InsertOneAsync(post);
  }

  public async Task RemoveAsync(string id)
  {
    await collection.DeleteOneAsync(x => x.Id == id);
  }

  public async Task UpdateAsync(string id, ChatMessage post)
  {
    await collection.ReplaceOneAsync(x => x.Id == id, post);
  }
}

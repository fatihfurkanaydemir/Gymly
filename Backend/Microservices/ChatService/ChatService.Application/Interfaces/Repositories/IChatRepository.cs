using ChatService.Domain.Entities;

namespace ChatService.Application.Interfaces.Repositories;

public interface IChatRepository
{
  public Task<IReadOnlyList<ChatMessage>> GetPagedReponseAsync(string senderId, string receiverId, int pageNumber, int pageSize);
  Task<int> GetDataCount(string senderId, string receiverId);
  public Task<ChatMessage> GetByIdAsync(string id);
  public Task AddAsync(ChatMessage post);
  public Task RemoveAsync(string id);
  public Task UpdateAsync(string id, ChatMessage post);
}

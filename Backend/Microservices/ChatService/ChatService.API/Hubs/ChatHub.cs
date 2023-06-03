namespace ChatService.API.Hubs;

using ChatService.Application.Interfaces.Repositories;
using ChatService.Domain.Entities;
using Microsoft.AspNetCore.SignalR;


public class ChatHub : Hub
{
  private IChatRepository _chatRepository;

  private readonly static ConnectionMapping<string> _connections =
     new ConnectionMapping<string>();

  public ChatHub(IChatRepository chatRepository)
  {
    _chatRepository = chatRepository;
  }

  public async Task JoinChat(string userId)
  {
    //if (_connections.GetConnections(userId).Count() > 0)
    //{
    //  return;
    //}

    Console.WriteLine("JoinedChat: " + userId);

    _connections.Add(userId, Context.ConnectionId);
  }

  public async Task LeaveChat(string userId)
  {
    _connections.Remove(userId, Context.ConnectionId);
    await Task.CompletedTask;
  }

  public async Task SendMessage(string message, string senderId, string receiverId)
  {
    var msg = new ChatMessage
    {
      SenderId = senderId,
      ReceiverId = receiverId,
      Message = message,
      MessageTime = DateTime.Now
    };

    if (_connections.GetConnections(receiverId).Count() > 0)
    {
      foreach (var conn in _connections.GetConnections(receiverId))
      {
        await Clients.Client(conn).SendAsync("ChatChannel", msg);
      }
    }

    await _chatRepository.AddAsync(msg);
  }
}
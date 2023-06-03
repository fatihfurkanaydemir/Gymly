using MongoDB.Bson;
using MongoDB.Bson.Serialization.Attributes;

namespace ChatService.Domain.Entities;

public class ChatMessage
{
  [BsonId]
  [BsonRepresentation(BsonType.ObjectId)]
  public string Id { get; set; } = ObjectId.GenerateNewId().ToString();

  public string SenderId { get; set; } = default!;

  public string ReceiverId { get; set; } = default!;

  public string Message { get; set; } = default!;

  public DateTime MessageTime { get; set; } = default!;
}
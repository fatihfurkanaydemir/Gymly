using MongoDB.Bson;
using MongoDB.Bson.Serialization.Attributes;

namespace PostService.Domain.Entities;

public class PostInteraction
{
  [BsonId]
  [BsonRepresentation(BsonType.ObjectId)]
  public string Id { get; set; } = ObjectId.GenerateNewId().ToString();

  [BsonElement("SubjectId")]
  public string SubjectId { get; set; }

  [BsonElement("PostId")]
  public string PostId { get; set; }

  [BsonElement("Amazed")]
  public bool Amazed { get; set; }

  [BsonElement("Celebration")]
  public bool Celebration { get; set; }

  [BsonElement("ReachedTarget")]
  public bool ReachedTarget { get; set; }

  [BsonElement("Flame")]
  public bool Flame { get; set; }

  [BsonElement("LostMind")]
  public bool LostMind { get; set; }
}

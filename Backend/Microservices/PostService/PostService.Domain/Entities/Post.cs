using MongoDB.Bson;
using MongoDB.Bson.Serialization.Attributes;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PostService.Domain.Entities;

public class Post
{
  [BsonId]
  [BsonRepresentation(BsonType.ObjectId)]
  public string Id { get; set; } = ObjectId.GenerateNewId().ToString();

  [BsonElement("CreateDate")]
  public DateTime CreateDate { get; set; } = DateTime.UtcNow;

  [BsonElement("SubjectId")]
  public string SubjectId { get; set; }

  [BsonElement("ImageUrls")]
  public List<string> ImageUrls { get; set; }

  [BsonElement("Content")]
  public string Content { get; set; }

  [BsonElement("AmazedCount")]
  public int AmazedCount { get; set; }

  [BsonElement("CelebrationCount")]
  public int CelebrationCount { get; set; }

  [BsonElement("ReachedTargetCount")]
  public int ReachedTargetCount { get; set; }

  [BsonElement("FlameCount")]
  public int FlameCount { get; set; }

  [BsonElement("LostMindCount")]
  public int LostMindCount { get; set; }
}

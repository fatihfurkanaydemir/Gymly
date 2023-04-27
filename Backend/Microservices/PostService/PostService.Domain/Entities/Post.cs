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

  [BsonElement("Date")]
  public DateTime CreateDate { get; set; } = DateTime.UtcNow;

  [BsonElement("SubjectId")]
  public string SubjectId { get; set; }

  [BsonElement("ImageUrl")]
  public string ImageUrl { get; set; }

  [BsonElement("Content")]
  public string Content { get; set; }

  [BsonElement("LikeCount")]
  public int LikeCount { get; set; }
}

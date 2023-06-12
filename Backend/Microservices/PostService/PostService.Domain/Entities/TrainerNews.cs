using MongoDB.Bson;
using MongoDB.Bson.Serialization.Attributes;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PostService.Domain.Entities;

public class TrainerNews
{
  [BsonId]
  [BsonRepresentation(BsonType.ObjectId)]
  public string Id { get; set; } = ObjectId.GenerateNewId().ToString();

  [BsonElement("CreateDate")]
  public DateTime CreateDate { get; set; } = DateTime.UtcNow;

  [BsonElement("SubjectId")]
  public string SubjectId { get; set; }

  [BsonElement("Title")]
  public string Title { get; set; }

  [BsonElement("Content")]
  public string Content { get; set; }
}

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ChatService.Infrastructure.Persistence.Settings;

public class MongoDbSettings
{
  public string ConnectionString { get; set; } = default!;
  public string DatabaseName { get; set; } = default!;
  public string ChatCollectionName { get; set; } = default!;
}

﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PostService.Infrastructure.Persistence.Settings;

public class MongoDbSettings
{
  public string ConnectionString { get; set; } = default!;
  public string DatabaseName { get; set; } = default!;
  public string PostCollectionName { get; set; } = default!;
  public string PostInteractionCollectionName { get; set; } = default!;
  public string TrainerNewsCollectionName { get; set; } = default!;
}

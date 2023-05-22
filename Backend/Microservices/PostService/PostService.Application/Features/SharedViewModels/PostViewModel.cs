using Common.Contracts;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PostService.Application.Features.SharedViewModels;

public class PostViewModel
{
  public string Id { get; set; } = default!;
  public DateTime CreateDate { get; set; } = default!;
  public string SubjectId { get; set; } = default!;
  public List<string> ImageUrls { get; set; } = default!;
  public string Content { get; set; } = default!;
  public int AmazedCount { get; set; }
  public int CelebrationCount { get; set; }
  public int ReachedTargetCount { get; set; }
  public int FlameCount { get; set; }
  public int LostMindCount { get; set; }
  public GetUserContractResult User { get; set; }
}

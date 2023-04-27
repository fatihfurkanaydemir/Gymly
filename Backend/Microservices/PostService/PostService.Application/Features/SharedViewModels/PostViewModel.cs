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
  public string ImageUrl { get; set; } = default!;
  public string Content { get; set; } = default!;
  public int LikeCount { get; set; } = default!;
}

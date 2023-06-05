using Common.Contracts;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PostService.Application.Features.SharedViewModels;

public class TrainerNewsViewModel
{
  public string Id { get; set; } = default!;
  public DateTime CreateDate { get; set; } = default!;
  public string SubjectId { get; set; } = default!;
  public string Title { get; set; } = default!;
  public string Content { get; set; } = default!;
}

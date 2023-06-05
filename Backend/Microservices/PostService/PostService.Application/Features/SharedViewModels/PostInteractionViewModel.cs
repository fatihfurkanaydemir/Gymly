namespace PostService.Application.Features.SharedViewModels;

public class PostInteractionViewModel
{
  public string Id { get; set; }
  public string SubjectId { get; set; }
  public string PostId { get; set; }
  public bool Amazed { get; set; }
  public bool Celebration { get; set; }
  public bool ReachedTarget { get; set; }
  public bool Flame { get; set; }
  public bool LostMind { get; set; }
}

using Common.Exceptions;
using Common.Helpers;
using Common.Wrappers;
using Mapster;
using MediatR;
using PostService.Application.Interfaces.Repositories;
using PostService.Domain.Entities;

namespace PostService.Application.Features.PostInteractions.Commands;

public class InteractWithPostCommand : IRequest<Response<string>>
{
  public string PostId { get; set; } = default!;
  public bool Amazed { get; set; } = default!;
  public bool Celebration { get; set; } = default!;
  public bool ReachedTarget { get; set; } = default!;
  public bool Flame { get; set; } = default!;
  public bool LostMind { get; set; } = default!;
}

record InteractionDiff
{
  public int AmazedDiff { get; set; }
  public int CelebrationDiff { get; set; }
  public int ReachedTargetDiff { get; set; }
  public int FlameDiff { get; set; }
  public int LostMindDiff { get; set; }
}

public class InteractWithPostCommandHandler : IRequestHandler<InteractWithPostCommand, Response<string>>
{
  private readonly IPostInteractionRepository _postInteractionRepository;
  private readonly IPostRepository _postRepository;
  private readonly IUserAccessor _userAccessor;
  public InteractWithPostCommandHandler(IPostInteractionRepository postInteractionRepository, IPostRepository postRepository, IUserAccessor userAccessor)
  {
    _postInteractionRepository = postInteractionRepository;
    _postRepository = postRepository;
    _userAccessor = userAccessor;
  }

  private InteractionDiff getInteractionDiff(PostInteraction newInteraction, PostInteraction? oldInteraction = null)
  {
    static int getDiff(bool newVal, bool oldVal) {
      if (newVal == oldVal) return 0;
      if (newVal && !oldVal) return 1;
      else return -1;
    }

    return new InteractionDiff
    {
      AmazedDiff = oldInteraction == null ? (newInteraction.Amazed ? 1 : 0) : (getDiff(newInteraction.Amazed, oldInteraction.Amazed)),
      CelebrationDiff = oldInteraction == null ? (newInteraction.Celebration ? 1 : 0) : (getDiff(newInteraction.Celebration, oldInteraction.Celebration)),
      ReachedTargetDiff = oldInteraction == null ? (newInteraction.ReachedTarget ? 1 : 0) : (getDiff(newInteraction.ReachedTarget, oldInteraction.ReachedTarget)),
      FlameDiff = oldInteraction == null ? (newInteraction.Flame ? 1 : 0) : (getDiff(newInteraction.Flame, oldInteraction.Flame)),
      LostMindDiff = oldInteraction == null ? (newInteraction.LostMind ? 1 : 0) : (getDiff(newInteraction.LostMind, oldInteraction.LostMind)),
    };
  }

  public async Task<Response<string>> Handle(InteractWithPostCommand command, CancellationToken cancellationToken)
  {
    var post = await _postRepository.GetByIdAsync(command.PostId);
    if (post == null) throw new ApiException("POST_NOT_FOUND");

    var dbInteraction = await _postInteractionRepository.GetByPostAndSubjectIdAsync(command.PostId, _userAccessor.SubjectId);

    var interaction = command.Adapt<PostInteraction>();
    interaction.SubjectId = _userAccessor.SubjectId;

    var diff = getInteractionDiff(interaction, dbInteraction);

    post.AmazedCount += diff.AmazedDiff;
    post.CelebrationCount += diff.CelebrationDiff;
    post.ReachedTargetCount += diff.ReachedTargetDiff;
    post.FlameCount += diff.FlameDiff;
    post.LostMindCount += diff.LostMindDiff;

    await _postRepository.UpdateAsync(post.Id, post);

    if (dbInteraction == null)
    {
      await _postInteractionRepository.AddAsync(interaction);

      return new Response<string>(interaction.Id.ToString(), "INTERACTION_CREATED");
    }

    dbInteraction.LostMind = command.LostMind;
    dbInteraction.ReachedTarget = command.ReachedTarget;
    dbInteraction.Amazed = command.Amazed;
    dbInteraction.Celebration = command.Celebration;
    dbInteraction.Flame = command.Flame;

    await _postInteractionRepository.UpdateAsync(dbInteraction.Id, dbInteraction);

    return new Response<string>(dbInteraction.Id.ToString(), "INTERACTION_UPDATED");
  }
}
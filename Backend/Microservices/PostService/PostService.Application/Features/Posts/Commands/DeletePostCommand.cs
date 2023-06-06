using Common.Exceptions;
using Common.Helpers;
using Common.Wrappers;
using Mapster;
using MediatR;
using PostService.Application.Interfaces.Repositories;
using PostService.Domain.Entities;
using System.Security.Claims;

namespace PostService.Application.Features.Posts.Commands;

public class DeletePostCommand : IRequest<Response<string>>
{
  public string Id { get; set; }
}

public class DeletePostCommandHandler : IRequestHandler<DeletePostCommand, Response<string>>
{
  private readonly IPostRepository _postRepository;
  private readonly IPostInteractionRepository _postInteractionRepository;
  private readonly IUserAccessor _userAccessor;
  public DeletePostCommandHandler(IPostRepository postRepository, IPostInteractionRepository postInteractionRepository, IUserAccessor userAccessor)
  {
    _postRepository = postRepository;
    _postInteractionRepository = postInteractionRepository;
    _userAccessor = userAccessor;
  }

  public async Task<Response<string>> Handle(DeletePostCommand request, CancellationToken cancellationToken)
  {
    var post = await _postRepository.GetByIdAsync(request.Id);
    if (post == null) throw new ApiException("POST_NOT_FOUND");
    if (post.SubjectId != _userAccessor.SubjectId) throw new ApiException("UNAUTHORIZED_OPERATION");

    await _postRepository.RemoveAsync(post.Id);
    await _postInteractionRepository.RemoveAllInteractionsOfPostAsync(post.Id);

    return new Response<string>(post.Id.ToString(), "POST_DELETED");
  }
}
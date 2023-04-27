using Common.Exceptions;
using Common.Wrappers;
using Mapster;
using MediatR;
using PostService.Application.Helpers;
using PostService.Application.Interfaces.Repositories;
using PostService.Domain.Entities;
using System.Security.Claims;

namespace PostService.Application.Features.Posts.Commands;

public class CreatePostCommand : IRequest<Response<string>>
{
  public string ImageUrl { get; set; }
  public string Content { get; set; }
  public int LikeCount { get; set; }
}

public class CreateUserCommandHandler : IRequestHandler<CreatePostCommand, Response<string>>
{
  private readonly IPostRepository _postRepository;
  private readonly IUserAccessor _userAccessor;
  public CreateUserCommandHandler(IPostRepository postRepository, IUserAccessor userAccessor)
  {
    _postRepository = postRepository;
    _userAccessor = userAccessor;
  }

  public async Task<Response<string>> Handle(CreatePostCommand request, CancellationToken cancellationToken)
  {
    var post = request.Adapt<Post>();

    post.SubjectId = _userAccessor.User.FindFirstValue(ClaimTypes.NameIdentifier);
    await _postRepository.AddAsync(post);

    return new Response<string>(post.Id.ToString(), "POST_CREATED");
  }
}
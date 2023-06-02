using Common.Exceptions;
using Common.Helpers;
using Common.Wrappers;
using Mapster;
using MediatR;
using PostService.Application.Interfaces.Repositories;
using PostService.Domain.Entities;
using System.Security.Claims;

namespace PostService.Application.Features.Posts.Commands;

public class CreatePostCommand : IRequest<Response<string>>
{
  public List<string> ImageUrls { get; set; }
  public string Content { get; set; }
}

public class CreatePostCommandHandler : IRequestHandler<CreatePostCommand, Response<string>>
{
  private readonly IPostRepository _postRepository;
  private readonly IUserAccessor _userAccessor;
  public CreatePostCommandHandler(IPostRepository postRepository, IUserAccessor userAccessor)
  {
    _postRepository = postRepository;
    _userAccessor = userAccessor;
  }

  public async Task<Response<string>> Handle(CreatePostCommand request, CancellationToken cancellationToken)
  {
    var post = request.Adapt<Post>();

    post.SubjectId = _userAccessor.SubjectId;
    await _postRepository.AddAsync(post);

    return new Response<string>(post.Id.ToString(), "POST_CREATED");
  }
}
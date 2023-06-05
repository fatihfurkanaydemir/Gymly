namespace PostService.Application.Features.Posts.Queries.GetPostById;

using PostService.Application.Interfaces.Repositories;
using PostService.Application.Features.SharedViewModels;
using MediatR;
using Mapster;
using MassTransit;
using Common.Contracts;
using System.ComponentModel.DataAnnotations;
using Common.Exceptions;

public class GetPostByIdQuery : IRequest<Common.Wrappers.Response<PostViewModel>>
{
  [Required]
  public string PostId { get; set; }
}

public class GetPostByIdQueryHandler : IRequestHandler<GetPostByIdQuery, Common.Wrappers.Response<PostViewModel>>
{
  private readonly IPostRepository _postRepository;
  private readonly IRequestClient<GetUserContract> _client;
  public GetPostByIdQueryHandler(IPostRepository postRepository, IRequestClient<GetUserContract> client)
  {
    _postRepository = postRepository;
    _client = client;
  }

  public async Task<Common.Wrappers.Response<PostViewModel>> Handle(GetPostByIdQuery request, CancellationToken cancellationToken)
  {
    var post = await _postRepository.GetByIdAsync(request.PostId);
    if (post == null) throw new ApiException("POST_NOT_FOUND");

    var user = (await _client.GetResponse<GetUserContractResult>(new GetUserContract(){SubjectId = post.SubjectId})).Message;
    var postViewModel = post.Adapt<PostViewModel>();
    postViewModel.User = user;

    return new Common.Wrappers.Response<PostViewModel>(postViewModel, "Post");
  }
}

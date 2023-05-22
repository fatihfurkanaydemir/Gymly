namespace PostService.Application.Features.Posts.Queries.GetAllUsers;

using PostService.Application.Interfaces.Repositories;
using PostService.Application.Features.SharedViewModels;
using Common.Wrappers;
using Common.Parameters;
using MediatR;
using Mapster;
using MassTransit;
using Common.Contracts;

public class GetAllPostsQuery : IRequest<PagedResponse<IEnumerable<PostViewModel>>>
{
  public int PageNumber { get; set; }
  public int PageSize { get; set; }
}

public class GetAllPostsQueryHandler : IRequestHandler<GetAllPostsQuery, PagedResponse<IEnumerable<PostViewModel>>>
{
  private readonly IPostRepository _postRepository;
  private readonly IRequestClient<GetUserContract> _client;
  public GetAllPostsQueryHandler(IPostRepository postRepository, IRequestClient<GetUserContract> client)
  {
    _postRepository = postRepository;
    _client = client;
  }

  public async Task<PagedResponse<IEnumerable<PostViewModel>>> Handle(GetAllPostsQuery request, CancellationToken cancellationToken)
  {

    var validFilter = request.Adapt<RequestParameter>();
    var dataCount = await _postRepository.GetDataCount();
    var posts = await _postRepository.GetPagedReponseAsync(request.PageNumber, request.PageSize);

    var postViewModels = new List<PostViewModel>();

    foreach (var p in posts)
    {
      var user = (await _client.GetResponse<GetUserContractResult>(new GetUserContract(){SubjectId = p.SubjectId})).Message;
      var postViewModel = p.Adapt<PostViewModel>();
      postViewModel.User = user;

      postViewModels.Add(postViewModel);
    }

    return new PagedResponse<IEnumerable<PostViewModel>>(postViewModels, validFilter.PageNumber, validFilter.PageSize, dataCount);
  }
}

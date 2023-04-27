namespace PostService.Application.Features.Posts.Queries.GetAllUsers;

using PostService.Application.Interfaces.Repositories;
using PostService.Application.Features.SharedViewModels;
using Common.Wrappers;
using Common.Parameters;
using MediatR;
using Mapster;
using PostService.Application.Helpers;

public class GetAllPostsQuery : IRequest<PagedResponse<IEnumerable<PostViewModel>>>
{
  public int PageNumber { get; set; }
  public int PageSize { get; set; }
}

public class GetAllPostsQueryHandler : IRequestHandler<GetAllPostsQuery, PagedResponse<IEnumerable<PostViewModel>>>
{
  private readonly IPostRepository _postRepository;
  private readonly IUserAccessor _userAccessor;
  public GetAllPostsQueryHandler(IPostRepository postRepository, IUserAccessor userAccessor)
  {
    _postRepository = postRepository;
    _userAccessor = userAccessor;
  }

  public async Task<PagedResponse<IEnumerable<PostViewModel>>> Handle(GetAllPostsQuery request, CancellationToken cancellationToken)
  {

    var validFilter = request.Adapt<RequestParameter>();
    var dataCount = await _postRepository.GetDataCount();
    var posts = await _postRepository.GetPagedReponseAsync(request.PageNumber, request.PageSize);

    var postViewModels = new List<PostViewModel>();

    foreach (var p in posts)
    {
      postViewModels.Add(p.Adapt<PostViewModel>());
    }

    return new PagedResponse<IEnumerable<PostViewModel>>(postViewModels, validFilter.PageNumber, validFilter.PageSize, dataCount);
  }
}

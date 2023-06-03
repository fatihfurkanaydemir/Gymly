//namespace ChatService.Application.Features.Posts.Queries.GetPostsBySubjectId;

//using ChatService.Application.Interfaces.Repositories;
//using ChatService.Application.Features.SharedViewModels;
//using Common.Wrappers;
//using Common.Parameters;
//using MediatR;
//using Mapster;
//using MassTransit;
//using Common.Contracts;

//public class GetPostsBySubjectIdQuery : IRequest<PagedResponse<IEnumerable<PostViewModel>>>
//{
//  public string SubjectId { get; set; }
//  public int PageNumber { get; set; }
//  public int PageSize { get; set; }
//}

//public class GetPostsBySubjectIdQueryHandler : IRequestHandler<GetPostsBySubjectIdQuery, PagedResponse<IEnumerable<PostViewModel>>>
//{
//  private readonly IChatRepository _postRepository;
//  private readonly IRequestClient<GetUserContract> _client;
//  public GetPostsBySubjectIdQueryHandler(IChatRepository postRepository, IRequestClient<GetUserContract> client)
//  {
//    _postRepository = postRepository;
//    _client = client;
//  }

//  public async Task<PagedResponse<IEnumerable<PostViewModel>>> Handle(GetPostsBySubjectIdQuery request, CancellationToken cancellationToken)
//  {

//    var validFilter = request.Adapt<RequestParameter>();
//    var dataCount = await _postRepository.GetDataCountBySubjectId(request.SubjectId);
//    var posts = await _postRepository.GetPagedReponseBySubjectIdAsync(request.SubjectId, request.PageNumber, request.PageSize);

//    var postViewModels = new List<PostViewModel>();

//    foreach (var p in posts)
//    {
//      var user = (await _client.GetResponse<GetUserContractResult>(new GetUserContract() { SubjectId = p.SubjectId })).Message;
//      var postViewModel = p.Adapt<PostViewModel>();
//      postViewModel.User = user;

//      postViewModels.Add(postViewModel);
//    }

//    return new PagedResponse<IEnumerable<PostViewModel>>(postViewModels, validFilter.PageNumber, validFilter.PageSize, dataCount);
//  }
//}

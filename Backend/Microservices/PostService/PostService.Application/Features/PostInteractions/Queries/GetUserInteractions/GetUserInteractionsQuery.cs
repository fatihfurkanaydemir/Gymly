namespace PostService.Application.Features.PostInteractions.Queries.GetUserInteractions;

using PostService.Application.Interfaces.Repositories;
using PostService.Application.Features.SharedViewModels;
using Common.Wrappers;
using MediatR;
using Mapster;
using Common.Helpers;

public class GetUserInteractionsQuery : IRequest<PagedResponse<IEnumerable<PostInteractionViewModel>>>
{

}

public class GetUserInteractionsQueryHandler : IRequestHandler<GetUserInteractionsQuery, PagedResponse<IEnumerable<PostInteractionViewModel>>>
{
  private readonly IPostInteractionRepository _postInteractionRepository;
  private readonly IUserAccessor _userAccessor;
  public GetUserInteractionsQueryHandler(IPostInteractionRepository postInteractionRepository, IUserAccessor userAccessor)
  {
    _postInteractionRepository = postInteractionRepository;
    _userAccessor = userAccessor;
  }

  public async Task<PagedResponse<IEnumerable<PostInteractionViewModel>>> Handle(GetUserInteractionsQuery request, CancellationToken cancellationToken)
  {
    var interactions = await _postInteractionRepository.GetInteractionsOfUser(_userAccessor.SubjectId);

    var postInteractionViewModels = new List<PostInteractionViewModel>();

    foreach (var p in interactions)
    {
      var postInteractionViewModel = p.Adapt<PostInteractionViewModel>();
      postInteractionViewModels.Add(postInteractionViewModel);
    }

    return new PagedResponse<IEnumerable<PostInteractionViewModel>>(postInteractionViewModels, 0, 0, postInteractionViewModels.Count);
  }
}

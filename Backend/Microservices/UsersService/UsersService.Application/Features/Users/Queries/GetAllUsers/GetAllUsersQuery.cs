namespace UsersService.Application.Features.Users.Queries.GetAllUsers;

using UsersService.Application.Interfaces.Repositories;
using UsersService.Application.Features.SharedViewModels;
using Common.Wrappers;
using Common.Parameters;
using MediatR;
using Mapster;

public class GetAllUsersQuery : IRequest<PagedResponse<IEnumerable<UserViewModel>>>
{
  public int PageNumber { get; set; }
  public int PageSize { get; set; }
}

public class GetAllUsersQueryHandler : IRequestHandler<GetAllUsersQuery, PagedResponse<IEnumerable<UserViewModel>>>
{
  private readonly IUserRepositoryAsync _UserRepository;
  public GetAllUsersQueryHandler(IUserRepositoryAsync UserRepository)
  {
    _UserRepository = UserRepository;
  }

  public async Task<PagedResponse<IEnumerable<UserViewModel>>> Handle(GetAllUsersQuery request, CancellationToken cancellationToken)
  {

    var validFilter = request.Adapt<RequestParameter>();
    var dataCount = await _UserRepository.GetDataCount();
    var Users = await _UserRepository.GetPagedReponseAsync(request.PageNumber, request.PageSize);

    var UserViewModels = new List<UserViewModel>();

    foreach (var p in Users)
    {
      var User = p.Adapt<UserViewModel>();
      UserViewModels.Add(User);
    }

    return new PagedResponse<IEnumerable<UserViewModel>>(UserViewModels, validFilter.PageNumber, validFilter.PageSize, dataCount);
  }
}

namespace UsersService.Application.Features.Users.Queries.GetAllUsers;

using UsersService.Application.Interfaces.Repositories;
using UsersService.Application.Features.SharedViewModels;
using Common.Wrappers;
using MediatR;
using Mapster;
using Common.Exceptions;

public class GetUserQuery : IRequest<Response<UserViewModel>>
{
  public string SubjectId { get; set; } = default!;
}

public class GetUserQueryHandler : IRequestHandler<GetUserQuery, Response<UserViewModel>>
{
  private readonly IUserRepositoryAsync _UserRepository;
  public GetUserQueryHandler(IUserRepositoryAsync UserRepository)
  {
    _UserRepository = UserRepository;
  }

  public async Task<Response<UserViewModel>> Handle(GetUserQuery request, CancellationToken cancellationToken)
  {
    var user = await _UserRepository.GetBySubjectIdAsync(request.SubjectId);
    if (user == null) throw new ApiException("User data not found");

    return new Response<UserViewModel>(user.Adapt<UserViewModel>());
  }
}

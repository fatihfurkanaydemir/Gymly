namespace UsersService.Application.Features.Users.Queries.GetAllUsers;

using UsersService.Application.Interfaces.Repositories;
using UsersService.Application.Features.SharedViewModels;
using Common.Wrappers;
using MediatR;
using Mapster;
using Common.Exceptions;
using Keycloak.AuthServices.Sdk.Admin;

public class GetUserQuery : IRequest<Response<UserViewModel>>
{
  public string SubjectId { get; set; } = default!;
}

public class GetUserQueryHandler : IRequestHandler<GetUserQuery, Response<UserViewModel>>
{
  private readonly IUserRepositoryAsync _UserRepository;
  readonly IKeycloakUserClient _kcClient;
  public GetUserQueryHandler(IUserRepositoryAsync UserRepository, IKeycloakUserClient kcClient)
  {
    _UserRepository = UserRepository;
    _kcClient = kcClient;
  }

  public async Task<Response<UserViewModel>> Handle(GetUserQuery request, CancellationToken cancellationToken)
  {
    var user = await _UserRepository.GetBySubjectIdAsync(request.SubjectId);
    if (user == null) throw new ApiException("User data not found");

    var viewModel = user.Adapt<UserViewModel>();

    var kcUser = await _kcClient.GetUser("gymly", user.SubjectId);
    viewModel.FirstName = kcUser.FirstName ?? "";
    viewModel.LastName = kcUser.LastName ?? "";

    return new Response<UserViewModel>(viewModel);
  }
}

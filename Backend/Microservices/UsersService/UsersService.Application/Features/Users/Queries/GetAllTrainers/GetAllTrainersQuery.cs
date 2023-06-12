namespace UsersService.Application.Features.Users.Queries.GetAllTrainers;

using UsersService.Application.Interfaces.Repositories;
using UsersService.Application.Features.SharedViewModels;
using Common.Wrappers;
using Common.Parameters;
using MediatR;
using Mapster;
using Keycloak.AuthServices.Sdk.Admin;

public class GetAllTrainersQuery : IRequest<PagedResponse<IEnumerable<TrainerViewModel>>>
{
  public int PageNumber { get; set; }
  public int PageSize { get; set; }
}

public class GetAllTrainersQueryHandler : IRequestHandler<GetAllTrainersQuery, PagedResponse<IEnumerable<TrainerViewModel>>>
{
  private readonly IUserRepositoryAsync _UserRepository;
  readonly IKeycloakUserClient _kcClient;
  public GetAllTrainersQueryHandler(IUserRepositoryAsync UserRepository, IKeycloakUserClient kcClient)
  {
    _UserRepository = UserRepository;
    _kcClient = kcClient;
  }

  public async Task<PagedResponse<IEnumerable<TrainerViewModel>>> Handle(GetAllTrainersQuery request, CancellationToken cancellationToken)
  {

    var validFilter = request.Adapt<RequestParameter>();
    var dataCount = await _UserRepository.GetTrainerDataCount();
    var Users = await _UserRepository.GetTrainersPagedAsync(request.PageNumber, request.PageSize);

    var trainerViewModels = new List<TrainerViewModel>();

    foreach (var p in Users)
    {
      var trainer = p.Adapt<TrainerViewModel>();
      var kcUser = await _kcClient.GetUser("gymly", p.SubjectId);
      trainer.AvatarUrl = p.AvatarUrl;
      trainer.FirstName = kcUser.FirstName ?? "";
      trainer.LastName = kcUser.LastName ?? "";

      trainerViewModels.Add(trainer);
    }

    return new PagedResponse<IEnumerable<TrainerViewModel>>(trainerViewModels, validFilter.PageNumber, validFilter.PageSize, dataCount);
  }
}

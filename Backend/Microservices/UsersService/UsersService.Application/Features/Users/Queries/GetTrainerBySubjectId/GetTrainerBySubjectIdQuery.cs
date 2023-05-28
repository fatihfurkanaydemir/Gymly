namespace UsersService.Application.Features.Users.Queries.GetTrainerBySubjectId;

using UsersService.Application.Interfaces.Repositories;
using UsersService.Application.Features.SharedViewModels;
using Common.Wrappers;
using Common.Parameters;
using MediatR;
using Mapster;
using Common.Exceptions;
using Keycloak.AuthServices.Sdk.Admin;

public class GetTrainerBySubjectIdQuery : IRequest<Response<TrainerViewModel>>
{
  public string SubjectId { get; set; }
}

public class GetTrainerBySubjectIdQueryHandler : IRequestHandler<GetTrainerBySubjectIdQuery, Response<TrainerViewModel>>
{
  private readonly IUserRepositoryAsync _UserRepository;
  readonly IKeycloakUserClient _kcClient;
  public GetTrainerBySubjectIdQueryHandler(IUserRepositoryAsync UserRepository, IKeycloakUserClient kcClient)
  {
    _UserRepository = UserRepository;
    _kcClient = kcClient;
  }

  public async Task<Response<TrainerViewModel>> Handle(GetTrainerBySubjectIdQuery request, CancellationToken cancellationToken)
  {
    var trainer = await _UserRepository.GetTrainerBySubjectIdAsync(request.SubjectId);
    if (trainer == null) throw new ApiException("Trainer not found");

    TrainerViewModel model = trainer.Adapt<TrainerViewModel>();

    var kcUser = await _kcClient.GetUser("gymly", trainer.SubjectId);
    model.AvatarUrl = ""; // TODO change
    model.FirstName = kcUser.FirstName ?? "";
    model.LastName = kcUser.LastName ?? "";

    return new Response<TrainerViewModel>(model, "TRAINER_FOUND");
  }
}

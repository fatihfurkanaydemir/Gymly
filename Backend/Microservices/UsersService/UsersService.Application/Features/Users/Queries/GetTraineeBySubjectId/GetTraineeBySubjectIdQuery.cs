namespace UsersService.Application.Features.Users.Queries.GetTraineeBySubjectId;

using UsersService.Application.Interfaces.Repositories;
using UsersService.Application.Features.SharedViewModels;
using Common.Wrappers;
using Common.Parameters;
using MediatR;
using Mapster;
using Common.Exceptions;
using Keycloak.AuthServices.Sdk.Admin;

public class GetTraineeBySubjectIdQuery : IRequest<Response<TraineeViewModel>>
{
  public string SubjectId { get; set; }
}

public class GetTraineeBySubjectIdQueryHandler : IRequestHandler<GetTraineeBySubjectIdQuery, Response<TraineeViewModel>>
{
  private readonly IUserRepositoryAsync _UserRepository;
  readonly IKeycloakUserClient _kcClient;
  public GetTraineeBySubjectIdQueryHandler(IUserRepositoryAsync UserRepository, IKeycloakUserClient kcClient)
  {
    _UserRepository = UserRepository;
    _kcClient = kcClient;
  }

  public async Task<Response<TraineeViewModel>> Handle(GetTraineeBySubjectIdQuery request, CancellationToken cancellationToken)
  {
    var trainee = await _UserRepository.GetBySubjectIdWithEnrolledProgramAsync(request.SubjectId);
    if (trainee == null) throw new ApiException("Trainee not found");

    TraineeViewModel model = trainee.Adapt<TraineeViewModel>();

    var kcUser = await _kcClient.GetUser("gymly", trainee.SubjectId);
    model.AvatarUrl = ""; // TODO change
    model.FirstName = kcUser.FirstName ?? "";
    model.LastName = kcUser.LastName ?? "";

    return new Response<TraineeViewModel>(model, "TRAINEE_FOUND");
  }
}

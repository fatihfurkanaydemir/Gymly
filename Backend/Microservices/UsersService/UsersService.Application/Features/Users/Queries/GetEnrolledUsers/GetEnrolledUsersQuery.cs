namespace UsersService.Application.Features.Users.Queries.GetEnrolledUsers;

using UsersService.Application.Interfaces.Repositories;
using UsersService.Application.Features.SharedViewModels;
using Common.Wrappers;
using Common.Parameters;
using MediatR;
using Mapster;
using Keycloak.AuthServices.Sdk.Admin;
using Common.Helpers;
using UsersService.Domain.Entities;

public class GetEnrolledUsersQuery : IRequest<Response<List<TraineeViewModel>>>
{
}

public class GetEnrolledUsersQueryHandler : IRequestHandler<GetEnrolledUsersQuery, Response<List<TraineeViewModel>>>
{
  private readonly IUserRepositoryAsync _UserRepository;
  private readonly ITrainerWorkoutProgramRepositoryAsync _trainerWorkoutProgramRepository;
  readonly IKeycloakUserClient _kcClient;
  private readonly IUserAccessor _userAccessor;
  public GetEnrolledUsersQueryHandler(IUserRepositoryAsync UserRepository, ITrainerWorkoutProgramRepositoryAsync trainerWorkoutProgramRepository, IUserAccessor userAccessor, IKeycloakUserClient kcClient)
  {
    _UserRepository = UserRepository;
    _trainerWorkoutProgramRepository = trainerWorkoutProgramRepository;
    _kcClient = kcClient;
    _userAccessor = userAccessor;
  }

  public async Task<Response<List<TraineeViewModel>>> Handle(GetEnrolledUsersQuery request, CancellationToken cancellationToken)
  {
    var trainer = await _UserRepository.GetBySubjectIdAsync(_userAccessor.SubjectId);
    var users = new List<User>();
    var trainees = new List<TraineeViewModel>();

    foreach(var program in trainer.TrainerWorkoutPrograms)
    {
      var dbProgram = await _trainerWorkoutProgramRepository.getByIdWithRelationsAsync(program.Id);
      var programViewModel = dbProgram.Adapt<TrainerWorkoutProgramViewModel>();
      foreach (var user in dbProgram.EnrolledUsers)
      {
        var traineeViewModel = user.Adapt<TraineeViewModel>();
        traineeViewModel.EnrolledProgram = programViewModel;

        var kcUser = await _kcClient.GetUser("gymly", traineeViewModel.SubjectId);
        traineeViewModel.FirstName = kcUser.FirstName ?? "";
        traineeViewModel.LastName = kcUser.LastName ?? "";

        trainees.Add(traineeViewModel);
      }
    }

    return new Response<List<TraineeViewModel>>(trainees, "");
  }
}

using Common.Exceptions;
using Common.Helpers;
using Common.Wrappers;
using Mapster;
using MediatR;
using UsersService.Application.Interfaces.Repositories;
using UsersService.Domain.Entities;

namespace UsersService.Application.Features.Users.Commands;

public class CancelUserEnrollmentCommand : IRequest<Response<string>>
{
}

public class CancelUserEnrollmentCommandHandler : IRequestHandler<CancelUserEnrollmentCommand, Response<string>>
{
  private readonly IUserRepositoryAsync _userRepository;
  private readonly ITrainerWorkoutProgramRepositoryAsync _trainerWorkoutProgramRepository;
  private readonly IUserAccessor _userAccessor;
  public CancelUserEnrollmentCommandHandler(IUserRepositoryAsync userRepository, ITrainerWorkoutProgramRepositoryAsync trainerWorkoutProgramRepository,  IUserAccessor userAccessor)
  {
    _userRepository = userRepository;
    _userAccessor = userAccessor;
    _trainerWorkoutProgramRepository = trainerWorkoutProgramRepository;
  }

  public async Task<Response<string>> Handle(CancelUserEnrollmentCommand request, CancellationToken cancellationToken)
  {
    var user = await _userRepository.GetBySubjectIdAsTrackingAsync(_userAccessor.SubjectId);
    if (user == null) throw new ApiException("USER_NOT_FOUND");

    if (user.EnrolledProgram == null) throw new ApiException("USER_NOT_ENROLLED");

    user.EnrolledProgram = null;
    await _userRepository.UpdateAsync(user);

    return new Response<string>(user.Id.ToString(), "ENROLLMENT_CANCELED");
  }
}
using Common.Exceptions;
using Common.Helpers;
using Common.Wrappers;
using Mapster;
using MediatR;
using System.Security.Claims;
using UsersService.Application.Interfaces.Repositories;
using UsersService.Domain.Entities;

namespace UsersService.Application.Features.Users.Commands;

public class EnrollUserToProgramCommand : IRequest<Response<string>>
{
  public int ProgramId { get; set; } = default;
}

public class EnrollUserToProgramCommandHandler : IRequestHandler<EnrollUserToProgramCommand, Response<string>>
{
  private readonly IUserRepositoryAsync _userRepository;
  private readonly ITrainerWorkoutProgramRepositoryAsync _trainerWorkoutProgramRepository;
  private readonly IUserAccessor _userAccessor;
  public EnrollUserToProgramCommandHandler(IUserRepositoryAsync userRepository, ITrainerWorkoutProgramRepositoryAsync trainerWorkoutProgramRepository, IUserAccessor userAccessor)
  {
    _userRepository = userRepository;
    _trainerWorkoutProgramRepository = trainerWorkoutProgramRepository;
    _userAccessor = userAccessor;
  }

  public async Task<Response<string>> Handle(EnrollUserToProgramCommand request, CancellationToken cancellationToken)
  {
    var user = await _userRepository.GetBySubjectIdAsync(_userAccessor.SubjectId);
    if (user == null) throw new ApiException("USER_NOT_FOUND");

    var program = await _trainerWorkoutProgramRepository.GetByIdAsync(request.ProgramId);
    if (program == null) throw new ApiException("PROGRAM_NOT_FOUND");

    user.EnrolledProgram = program;
    await _userRepository.UpdateAsync(user);

    program.EnrolledUsers.Add(user);
    await _trainerWorkoutProgramRepository.UpdateAsync(program);

    return new Response<string>(program.Id.ToString(), "USER_ENROLLED_TO_PROGRAM");
  }
}
using Common.Exceptions;
using Common.Wrappers;
using Mapster;
using MediatR;
using UsersService.Application.Interfaces.Repositories;
using UsersService.Domain.Entities;

namespace UsersService.Application.Features.Users.Commands;

public class CreateUserWorkoutProgramCommand : IRequest<Response<string>>
{
  public string SubjectId { get; set; } = default!;
  public string Title { get; set; } = default!;
  public string Description { get; set; } = default!;
  public string Content { get; set; } = default!;
}

public class CreateUserWorkoutProgramCommandHandler : IRequestHandler<CreateUserWorkoutProgramCommand, Response<string>>
{
  private readonly IUserRepositoryAsync _userRepository;
  private readonly IUserWorkoutProgramRepositoryAsync _userWorkoutProgramRepository;
  public CreateUserWorkoutProgramCommandHandler(IUserRepositoryAsync userRepository, IUserWorkoutProgramRepositoryAsync userWorkoutProgramRepository)
  {
    _userRepository = userRepository;
    _userWorkoutProgramRepository = userWorkoutProgramRepository;
  }

  public async Task<Response<string>> Handle(CreateUserWorkoutProgramCommand request, CancellationToken cancellationToken)
  {
    var user = await _userRepository.GetBySubjectIdAsync(request.SubjectId);
    if (user == null) throw new ApiException("USER_NOT_FOUND");

    if (request.Title.Trim() == "" || request.Content.Trim() == "") throw new ApiException("INVALID_VALUES");

    var workoutProgram = request.Adapt<UserWorkoutProgram>();
    var addedProgram = await _userWorkoutProgramRepository.AddAsync(workoutProgram);

    user.UserWorkoutPrograms.Add(addedProgram);
    await _userRepository.UpdateAsync(user);

    return new Response<string>(addedProgram.Id.ToString(), "WORKOUT_PROGRAM_CREATED");
  }
}
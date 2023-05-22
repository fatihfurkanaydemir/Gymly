using Common.Exceptions;
using Common.Wrappers;
using Mapster;
using MediatR;
using UsersService.Application.Interfaces.Repositories;
using UsersService.Domain.Entities;

namespace UsersService.Application.Features.Users.Commands;

public class CreateTrainerWorkoutProgramCommand : IRequest<Response<string>>
{
  public string SubjectId { get; set; } = default!;
  public string Name { get; set; } = default!;
  public string Title { get; set; } = default!;
  public string Description { get; set; } = default!;
  public string HeaderImageUrl { get; set; } = default!;
  public string ProgramDetails { get; set; } = default!;
}

public class CreateTrainerWorkoutProgramCommandHandler : IRequestHandler<CreateTrainerWorkoutProgramCommand, Response<string>>
{
  private readonly IUserRepositoryAsync _userRepository;
  private readonly ITrainerWorkoutProgramRepositoryAsync _trainerWorkoutProgramRepository;
  public CreateTrainerWorkoutProgramCommandHandler(IUserRepositoryAsync userRepository, ITrainerWorkoutProgramRepositoryAsync trainerWorkoutProgramRepository)
  {
    _userRepository = userRepository;
    _trainerWorkoutProgramRepository = trainerWorkoutProgramRepository;
  }

  public async Task<Response<string>> Handle(CreateTrainerWorkoutProgramCommand request, CancellationToken cancellationToken)
  {
    var user = await _userRepository.GetBySubjectIdAsync(request.SubjectId);
    if (user == null) throw new ApiException("USER_NOT_FOUND");

    if (
      request.Name.Trim() == "" ||
      request.Title.Trim() == "" ||
      request.Description.Trim() == "" ||
      request.HeaderImageUrl.Trim() == "" ||
      request.ProgramDetails.Trim() == ""
      ) throw new ApiException("INVALID_VALUES");

    var workoutProgram = request.Adapt<TrainerWorkoutProgram>();
    var addedProgram = await _trainerWorkoutProgramRepository.AddAsync(workoutProgram);

    user.TrainerWorkoutPrograms.Add(addedProgram);
    await _userRepository.UpdateAsync(user);

    return new Response<string>(addedProgram.Id.ToString(), "WORKOUT_PROGRAM_CREATED");
  }
}
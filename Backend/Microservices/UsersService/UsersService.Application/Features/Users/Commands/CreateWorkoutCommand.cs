using Common.Exceptions;
using Common.Helpers;
using Common.Wrappers;
using Mapster;
using MediatR;
using System.ComponentModel.DataAnnotations;
using UsersService.Application.Interfaces.Repositories;
using UsersService.Domain.Entities;

namespace UsersService.Application.Features.Users.Commands;

public class CreateWorkoutCommand : IRequest<Response<string>>
{
  [Required]
  public int DurationInMinutes { get; set; } = default!;
  [Required]
  public int UserWorkoutProgramId { get; set; } = default!;
}

public class CreateWorkoutCommandHandler : IRequestHandler<CreateWorkoutCommand, Response<string>>
{
  private readonly IWorkoutRepositoryAsync _workoutRepository;
  private readonly IUserWorkoutProgramRepositoryAsync _userWorkoutProgramRepository;
  private readonly IUserAccessor _userAccessor;
  public CreateWorkoutCommandHandler(IWorkoutRepositoryAsync workoutRepository, IUserWorkoutProgramRepositoryAsync userWorkoutProgramRepository, IUserAccessor userAccessor)
  {
    _workoutRepository = workoutRepository;
    _userWorkoutProgramRepository = userWorkoutProgramRepository;
    _userAccessor = userAccessor;
  }

  public async Task<Response<string>> Handle(CreateWorkoutCommand request, CancellationToken cancellationToken)
  {
    if (request.DurationInMinutes <= 1) throw new ApiException("INVALID_VALUES");

    var workoutProgram = await _userWorkoutProgramRepository.GetByIdAsync(request.UserWorkoutProgramId);
    if (workoutProgram == null) throw new ApiException("WORKOUT_PROGRAM_NOT_FOUND");

    var workout = request.Adapt<Workout>();
    workout.ProgramDescription = workoutProgram.Description;
    workout.ProgramContent = workoutProgram.Content;
    workout.ProgramTitle = workoutProgram.Title;
    workout.SubjectId = _userAccessor.SubjectId;

    var addedWorkout = await _workoutRepository.AddAsync(workout);

    return new Response<string>(addedWorkout.Id.ToString(), "WORKOUT_PROGRAM_CREATED");
  }
}
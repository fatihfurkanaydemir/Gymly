using Common.Exceptions;
using Common.Helpers;
using Common.Wrappers;
using Mapster;
using MediatR;
using UsersService.Application.Interfaces.Repositories;
using UsersService.Domain.Entities;

namespace UsersService.Application.Features.Users.Commands;

public class DeleteWorkoutCommand  : IRequest<Response<string>>
{
  public int Id { get; set; } = default!;
}

public class DeleteWorkoutCommandHandler : IRequestHandler<DeleteWorkoutCommand , Response<string>>
{
  private readonly IWorkoutRepositoryAsync _workoutRepository;
  public DeleteWorkoutCommandHandler(IWorkoutRepositoryAsync workoutRepository)
  {
    _workoutRepository = workoutRepository;
  }

  public async Task<Response<string>> Handle(DeleteWorkoutCommand  request, CancellationToken cancellationToken)
  {
    var workout = await _workoutRepository.GetByIdAsync(request.Id);
    if (workout == null) throw new ApiException("WORKOUT_NOT_FOUND");

    await _workoutRepository.DeleteAsync(workout);

    return new Response<string>(workout.Id.ToString(), "WORKOUT_DELETED");
  }
}
using Common.Exceptions;
using Common.Wrappers;
using Mapster;
using MediatR;
using UsersService.Application.Interfaces.Repositories;
using UsersService.Domain.Entities;

namespace UsersService.Application.Features.Users.Commands;

public class DeleteTrainerWorkoutProgramCommand : IRequest<Response<string>>
{
  public string SubjectId { get; set; } = default!;
  public int Id { get; set; } = default!;
}

public class DeleteTrainerWorkoutProgramCommandHandler : IRequestHandler<DeleteTrainerWorkoutProgramCommand, Response<string>>
{
  private readonly ITrainerWorkoutProgramRepositoryAsync _trainerWorkoutProgramRepository;
  public DeleteTrainerWorkoutProgramCommandHandler(ITrainerWorkoutProgramRepositoryAsync trainerWorkoutProgramRepository)
  {
    _trainerWorkoutProgramRepository = trainerWorkoutProgramRepository;
  }

  public async Task<Response<string>> Handle(DeleteTrainerWorkoutProgramCommand request, CancellationToken cancellationToken)
  {
    var program = await _trainerWorkoutProgramRepository.GetByIdAsync(request.Id);
    if (program == null) throw new ApiException("PROGRAM_NOT_FOUND");

    await _trainerWorkoutProgramRepository.DeleteAsync(program);

    return new Response<string>(program.Id.ToString(), "WORKOUT_PROGRAM_DELETED");
  }
}
using Common.Exceptions;
using Common.Wrappers;
using Mapster;
using MediatR;
using UsersService.Application.Interfaces.Repositories;
using UsersService.Domain.Entities;

namespace UsersService.Application.Features.Users.Commands;

public class DeleteUserWorkoutProgramCommand  : IRequest<Response<string>>
{
  public string SubjectId { get; set; } = default!;
  public int Id { get; set; } = default!;
}

public class DeleteUserWorkoutProgramCommandHandler : IRequestHandler<DeleteUserWorkoutProgramCommand , Response<string>>
{
  private readonly IUserWorkoutProgramRepositoryAsync _userWorkoutProgramRepository;
  public DeleteUserWorkoutProgramCommandHandler(IUserWorkoutProgramRepositoryAsync userWorkoutProgramRepository)
  {
    _userWorkoutProgramRepository = userWorkoutProgramRepository;
  }

  public async Task<Response<string>> Handle(DeleteUserWorkoutProgramCommand  request, CancellationToken cancellationToken)
  {
    var program = await _userWorkoutProgramRepository.GetByIdAsync(request.Id);
    if (program == null) throw new ApiException("PROGRAM_NOT_FOUND");

    await _userWorkoutProgramRepository.DeleteAsync(program);

    return new Response<string>(program.Id.ToString(), "WORKOUT_PROGRAM_DELETED");
  }
}
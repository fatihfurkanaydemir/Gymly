using Common.Exceptions;
using Common.Wrappers;
using Mapster;
using MediatR;
using UsersService.Application.Interfaces.Repositories;
using UsersService.Domain.Entities;

namespace UsersService.Application.Features.Users.Commands;

public class UpdateUserWorkoutProgramCommand  : IRequest<Response<string>>
{
  public string SubjectId { get; set; } = default!;
  public int Id { get; set; } = default!;
  public string Title { get; set; } = default!;
  public string Description { get; set; } = default!;
  public string Content { get; set; } = default!;
}

public class UpdateUserWorkoutProgramCommandHandler : IRequestHandler<UpdateUserWorkoutProgramCommand , Response<string>>
{
  private readonly IUserWorkoutProgramRepositoryAsync _userWorkoutProgramRepository;
  public UpdateUserWorkoutProgramCommandHandler(IUserWorkoutProgramRepositoryAsync userWorkoutProgramRepository)
  {
    _userWorkoutProgramRepository = userWorkoutProgramRepository;
  }

  public async Task<Response<string>> Handle(UpdateUserWorkoutProgramCommand  request, CancellationToken cancellationToken)
  {
    var program = await _userWorkoutProgramRepository.GetByIdAsync(request.Id);
    if (program == null) throw new ApiException("PROGRAM_NOT_FOUND");

    if (request.Title.Trim() == "" || request.Content.Trim() == "") throw new ApiException("INVALID_VALUES");

    program.Title = request.Title;
    program.Description = request.Description;
    program.Content = request.Content;

    await _userWorkoutProgramRepository.UpdateAsync(program);

    return new Response<string>(program.Id.ToString(), "WORKOUT_PROGRAM_UPDATED");
  }
}
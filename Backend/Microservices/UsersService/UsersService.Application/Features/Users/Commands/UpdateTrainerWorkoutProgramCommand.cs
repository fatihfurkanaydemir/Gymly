using Common.Exceptions;
using Common.Wrappers;
using Mapster;
using MediatR;
using UsersService.Application.Interfaces.Repositories;
using UsersService.Domain.Entities;

namespace UsersService.Application.Features.Users.Commands;

public class UpdateTrainerWorkoutProgramCommand : IRequest<Response<string>>
{
  public string SubjectId { get; set; } = default!;
  public int Id { get; set; } = default!;
  public string Name { get; set; } = default!;
  public double Price { get; set; } = default!;
  public string Title { get; set; } = default!;
  public string Description { get; set; } = default!;
  public string HeaderImageUrl { get; set; } = default!;
  public string ProgramDetails { get; set; } = default!;
}

public class UpdateTrainerWorkoutProgramCommandHandler : IRequestHandler<UpdateTrainerWorkoutProgramCommand, Response<string>>
{
  private readonly ITrainerWorkoutProgramRepositoryAsync _trainerWorkoutProgramRepository;
  public UpdateTrainerWorkoutProgramCommandHandler(ITrainerWorkoutProgramRepositoryAsync trainerWorkoutProgramRepository)
  {
    _trainerWorkoutProgramRepository = trainerWorkoutProgramRepository;
  }

  public async Task<Response<string>> Handle(UpdateTrainerWorkoutProgramCommand request, CancellationToken cancellationToken)
  {
    var program = await _trainerWorkoutProgramRepository.GetByIdAsync(request.Id);
    if (program == null) throw new ApiException("PROGRAM_NOT_FOUND");

    if (
      request.Name.Trim() == "" ||
      request.Title.Trim() == "" ||
      request.Description.Trim() == "" ||
      request.HeaderImageUrl.Trim() == "" ||
      request.ProgramDetails.Trim() == "" ||
      request.Price < 1.0
      ) throw new ApiException("INVALID_VALUES");

    program.Name = request.Name;
    program.Title = request.Title;
    program.Description = request.Description;
    program.HeaderImageUrl = request.HeaderImageUrl;
    program.ProgramDetails = request.ProgramDetails;
    program.Price = request.Price;

    await _trainerWorkoutProgramRepository.UpdateAsync(program);

    return new Response<string>(program.Id.ToString(), "WORKOUT_PROGRAM_UPDATED");
  }
}
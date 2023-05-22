using Common.Exceptions;
using Common.Wrappers;
using Mapster;
using MediatR;
using UsersService.Application.Interfaces.Repositories;
using UsersService.Domain.Entities;

namespace UsersService.Application.Features.Users.Commands;

public class UpdateUserMeasurementsCommand : IRequest<Response<string>>
{
  public string SubjectId { get; set; } = default!;
  public double Weight { get; set; } = default!;
  public double Height { get; set; } = default!;
}

public class UpdateUserMeasurementsCommandHandler : IRequestHandler<UpdateUserMeasurementsCommand, Response<string>>
{
  private readonly IUserRepositoryAsync _userRepository;
  public UpdateUserMeasurementsCommandHandler(IUserRepositoryAsync userRepository)
  {
    _userRepository = userRepository;
  }

  public async Task<Response<string>> Handle(UpdateUserMeasurementsCommand request, CancellationToken cancellationToken)
  {
    var user = await _userRepository.GetBySubjectIdAsync(request.SubjectId);
    if(user == null) throw new ApiException("USER_NOT_FOUND");

    if(request.Weight <= 1 || request.Height <= 1) throw new ApiException("UNVALID_VALUES");
    
    user.Weight = request.Weight;
    user.Height = request.Height;

    await _userRepository.UpdateAsync(user);

    return new Response<string>(user.Id.ToString(), "MEASUREMENTS_UPDATED");
  }
}
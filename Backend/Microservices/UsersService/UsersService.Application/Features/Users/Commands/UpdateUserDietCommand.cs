using Common.Exceptions;
using Common.Wrappers;
using Mapster;
using MediatR;
using UsersService.Application.Interfaces.Repositories;
using UsersService.Domain.Entities;

namespace UsersService.Application.Features.Users.Commands;

public class UpdateUserDietCommand : IRequest<Response<string>>
{
  public string SubjectId { get; set; } = default!;
  public string Diet { get; set; } = default!;
}

public class UpdateUserDietCommandHandler : IRequestHandler<UpdateUserDietCommand, Response<string>>
{
  private readonly IUserRepositoryAsync _userRepository;
  public UpdateUserDietCommandHandler(IUserRepositoryAsync userRepository)
  {
    _userRepository = userRepository;
  }

  public async Task<Response<string>> Handle(UpdateUserDietCommand request, CancellationToken cancellationToken)
  {
    var user = await _userRepository.GetBySubjectIdAsync(request.SubjectId);
    if(user == null) throw new ApiException("USER_NOT_FOUND");

    if(request.Diet.Trim() == "") throw new ApiException("INVALID_VALUE");
    
    user.Diet = request.Diet;

    await _userRepository.UpdateAsync(user);

    return new Response<string>(user.Id.ToString(), "DIET_UPDATED");
  }
}
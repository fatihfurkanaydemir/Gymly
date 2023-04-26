using Common.Exceptions;
using Common.Wrappers;
using Mapster;
using MediatR;
using UsersService.Application.Interfaces.Repositories;
using UsersService.Domain.Entities;
using UsersService.Domain.Enums;

namespace UsersService.Application.Features.Users.Commands;

public class SwitchToTrainerAccountTypeCommand : IRequest<Response<string>>
{
  public string SubjectId { get; set; } = default!;
}

public class SwitchToTrainerAccountTypeCommandHandler : IRequestHandler<SwitchToTrainerAccountTypeCommand, Response<string>>
{
  private readonly IUserRepositoryAsync _userRepository;
  public SwitchToTrainerAccountTypeCommandHandler(IUserRepositoryAsync userRepository)
  {
    _userRepository = userRepository;
  }

  public async Task<Response<string>> Handle(SwitchToTrainerAccountTypeCommand request, CancellationToken cancellationToken)
  {
    var user = await _userRepository.GetBySubjectIdAsync(request.SubjectId);
    if (user == null) throw new ApiException("USER_NOT_FOUND");
    user.Type = UserType.Trainer;

    await _userRepository.UpdateAsync(user);

    return new Response<string>(user.Id.ToString(), "ACCOUNT_TYPE_CHANGED_TO_TRAINER");
  }
}
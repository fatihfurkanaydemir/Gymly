using Common.Exceptions;
using Common.Helpers;
using Common.Wrappers;
using MediatR;
using System.ComponentModel.DataAnnotations;
using UsersService.Application.Interfaces.Repositories;

namespace UsersService.Application.Features.Users.Commands;

public class UpdateUserAvatarCommand : IRequest<Response<string>>
{
  [Required]
  public string url { get; set; } = default!;
}

public class UpdateUserAvatarCommandHandler : IRequestHandler<UpdateUserAvatarCommand, Response<string>>
{
  private readonly IUserRepositoryAsync _userRepository;
  private readonly IUserAccessor _userAccessor;
  public UpdateUserAvatarCommandHandler(IUserRepositoryAsync userRepository, IUserAccessor userAccessor)
  {
    _userRepository = userRepository;
    _userAccessor = userAccessor;
  }

  public async Task<Response<string>> Handle(UpdateUserAvatarCommand request, CancellationToken cancellationToken)
  {
    var user = await _userRepository.GetBySubjectIdAsync(_userAccessor.SubjectId);
    if(user == null) throw new ApiException("USER_NOT_FOUND");
    
    user.AvatarUrl = request.url;

    await _userRepository.UpdateAsync(user);

    return new Response<string>(user.Id.ToString(), "AVATAR_UPDATED");
  }
}
using Common.Exceptions;
using Common.Helpers;
using Common.Wrappers;
using Mapster;
using MediatR;
using System.ComponentModel.DataAnnotations;
using UsersService.Application.Interfaces.Repositories;
using UsersService.Domain.Entities;

namespace UsersService.Application.Features.Users.Commands;

public class UpdateUserDietCommand : IRequest<Response<string>>
{
  [Required]
  public string Diet { get; set; } = default!;
}

public class UpdateUserDietCommandHandler : IRequestHandler<UpdateUserDietCommand, Response<string>>
{
  private readonly IUserRepositoryAsync _userRepository;
  private readonly IUserAccessor _userAccessor;
  public UpdateUserDietCommandHandler(IUserRepositoryAsync userRepository, IUserAccessor userAccessor)
  {
    _userRepository = userRepository;
    _userAccessor = userAccessor;
  }

  public async Task<Response<string>> Handle(UpdateUserDietCommand request, CancellationToken cancellationToken)
  {
    var user = await _userRepository.GetBySubjectIdAsync(_userAccessor.SubjectId);
    if(user == null) throw new ApiException("USER_NOT_FOUND");
    
    user.Diet = request.Diet;

    await _userRepository.UpdateAsync(user);

    return new Response<string>(user.Id.ToString(), "DIET_UPDATED");
  }
}
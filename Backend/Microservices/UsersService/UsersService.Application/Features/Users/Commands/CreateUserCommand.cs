using Common.Exceptions;
using Common.Wrappers;
using Mapster;
using MediatR;
using UsersService.Application.Interfaces.Repositories;
using UsersService.Domain.Entities;

namespace UsersService.Application.Features.Users.Commands;

public class CreateUserCommand : IRequest<Response<string>>
{
  public string SubjectId { get; set; } = default!;
}

public class CreateUserCommandHandler : IRequestHandler<CreateUserCommand, Response<string>>
{
  private readonly IUserRepositoryAsync _userRepository;
  public CreateUserCommandHandler(IUserRepositoryAsync userRepository)
  {
    _userRepository = userRepository;
  }

  public async Task<Response<string>> Handle(CreateUserCommand request, CancellationToken cancellationToken)
  {
    var existingUser = await _userRepository.GetBySubjectIdAsync(request.SubjectId);
    if(existingUser != null)
    {
      throw new ApiException("USER_EXISTS");
    }

    var user = new User
    {
      SubjectId = request.SubjectId,
      Diet = "",
      Gender = ""
    };

    await _userRepository.AddAsync(user);

    return new Response<string>(user.Id.ToString(), "User created");
  }
}
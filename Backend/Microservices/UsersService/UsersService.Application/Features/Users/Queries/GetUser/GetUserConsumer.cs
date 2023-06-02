using MassTransit;
using Common.Contracts;
using UsersService.Application.Interfaces.Repositories;
using Common.Exceptions;
using Mapster;
using Keycloak.AuthServices.Sdk.Admin;

namespace OtherService.Application.Features.Entities.Queries.GetEntity
{
  public class GetUserConsumer : IConsumer<GetUserContract>
  {
    readonly IUserRepositoryAsync _userRepository;
    readonly IKeycloakUserClient _kcClient;

    public GetUserConsumer(IUserRepositoryAsync userRepository, IKeycloakUserClient kcClient)
    {
      _userRepository = userRepository;
      _kcClient = kcClient;
    }

    public async Task Consume(ConsumeContext<GetUserContract> context)
    {
      var user = await _userRepository.GetBySubjectIdMinAsync(context.Message.SubjectId);
      if (user == null) throw new ApiException($"User data not found ({context.Message.SubjectId})");

      var result = user.Adapt<GetUserContractResult>();

      var kcUser = await _kcClient.GetUser("gymly", user.SubjectId);
      result.AvatarUrl = user.AvatarUrl;
      result.FirstName = kcUser.FirstName ?? "";
      result.LastName = kcUser.LastName ?? "";

      await context.RespondAsync(result);
    }
  }
}

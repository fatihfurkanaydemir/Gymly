using Common.Exceptions;
using Common.Helpers;
using Common.Wrappers;
using MediatR;
using PostService.Application.Interfaces.Repositories;

namespace PostService.Application.Features.TrainerNews.Commands;

public class DeleteTrainerNewsCommand : IRequest<Response<string>>
{
  public string Id { get; set; } = default!;
}

public class DeleteTrainerNewsCommandHandler : IRequestHandler<DeleteTrainerNewsCommand, Response<string>>
{
  private readonly ITrainerNewsRepository _trainerNewsRepository;
  private readonly IUserAccessor _userAccessor;
  public DeleteTrainerNewsCommandHandler(ITrainerNewsRepository trainerNewsRepository, IUserAccessor userAccessor)
  {
    _trainerNewsRepository = trainerNewsRepository;
    _userAccessor = userAccessor;
  }

  public async Task<Response<string>> Handle(DeleteTrainerNewsCommand request, CancellationToken cancellationToken)
  {
    var news = await _trainerNewsRepository.GetByIdAsync(request.Id);
    if (news == null) throw new ApiException("NEWS_NOT_FOUND");

    if (news.SubjectId != _userAccessor.SubjectId) throw new ApiException("UNAUTHORIZED_REQUEST");

    await _trainerNewsRepository.RemoveAsync(news.Id);

    return new Response<string>(request.Id.ToString(), "TRAINER_NEWS_DELETED");
  }
}
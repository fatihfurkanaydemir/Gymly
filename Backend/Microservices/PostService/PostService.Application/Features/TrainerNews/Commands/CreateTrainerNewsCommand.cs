using Common.Exceptions;
using Common.Helpers;
using Common.Wrappers;
using Mapster;
using MediatR;
using PostService.Application.Interfaces.Repositories;
using PostService.Domain.Entities;

namespace PostService.Application.Features.TrainerNews.Commands;

public class CreateTrainerNewsCommand : IRequest<Response<string>>
{
  public string Title { get; set; } = default!;
  public string Content { get; set; } = default!;
}

public class CreateTrainerNewsCommandHandler : IRequestHandler<CreateTrainerNewsCommand, Response<string>>
{
  private readonly ITrainerNewsRepository _trainerNewsRepository;
  private readonly IUserAccessor _userAccessor;
  public CreateTrainerNewsCommandHandler(ITrainerNewsRepository trainerNewsRepository, IUserAccessor userAccessor)
  {
    _trainerNewsRepository = trainerNewsRepository;
    _userAccessor = userAccessor;
  }

  public async Task<Response<string>> Handle(CreateTrainerNewsCommand request, CancellationToken cancellationToken)
  {
    var news = request.Adapt<PostService.Domain.Entities.TrainerNews>();

    news.SubjectId = _userAccessor.SubjectId;
    await _trainerNewsRepository.AddAsync(news);

    return new Response<string>(news.Id.ToString(), "TRAINER_NEWS_CREATED");
  }
}
namespace PostService.Application.Features.TrainerNews.Queries.GetTrainerNewsBySubjectId;

using PostService.Application.Interfaces.Repositories;
using PostService.Application.Features.SharedViewModels;
using Common.Wrappers;
using Common.Parameters;
using MediatR;
using Mapster;
using Common.Helpers;
using System.ComponentModel.DataAnnotations;

public class GetTrainerNewsBySubjectIdQuery : IRequest<PagedResponse<IEnumerable<TrainerNewsViewModel>>>
{
  [Required]
  public string SubjectId { get; set; }
  public int PageNumber { get; set; }
  public int PageSize { get; set; }
}

public class GetTrainerNewsBySubjectIdQueryHandler : IRequestHandler<GetTrainerNewsBySubjectIdQuery, PagedResponse<IEnumerable<TrainerNewsViewModel>>>
{
  private readonly ITrainerNewsRepository _trainerNewsRepository;
  public GetTrainerNewsBySubjectIdQueryHandler(ITrainerNewsRepository trainerNewsRepository)
  {
    _trainerNewsRepository = trainerNewsRepository;
  }

  public async Task<PagedResponse<IEnumerable<TrainerNewsViewModel>>> Handle(GetTrainerNewsBySubjectIdQuery request, CancellationToken cancellationToken)
  {
    var validFilter = request.Adapt<RequestParameter>();
    var dataCount = await _trainerNewsRepository.GetDataCountBySubjectId(request.SubjectId);
    var news = await _trainerNewsRepository.GetPagedReponseBySubjectIdAsync(request.SubjectId, request.PageNumber, request.PageSize);

    var newsViewModels = new List<TrainerNewsViewModel>();

    foreach (var p in news)
    {
      var newsViewModel = p.Adapt<TrainerNewsViewModel>();

      newsViewModels.Add(newsViewModel);
    }

    return new PagedResponse<IEnumerable<TrainerNewsViewModel>>(newsViewModels, validFilter.PageNumber, validFilter.PageSize, dataCount);
  }
}

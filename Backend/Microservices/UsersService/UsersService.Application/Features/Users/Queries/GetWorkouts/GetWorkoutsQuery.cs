namespace UsersService.Application.Features.Users.Queries.GetAllUsers;

using UsersService.Application.Interfaces.Repositories;
using UsersService.Application.Features.SharedViewModels;
using Common.Wrappers;
using Common.Parameters;
using MediatR;
using Mapster;
using Common.Helpers;
using System.ComponentModel.DataAnnotations;

public class GetWorkoutsQuery : IRequest<PagedResponse<IEnumerable<WorkoutViewModel>>>
{
  [Required]
  public string SubjectId { get; set; } = default!;
  public int PageNumber { get; set; }
  public int PageSize { get; set; }
}

public class GetWorkoutsQueryHandler : IRequestHandler<GetWorkoutsQuery, PagedResponse<IEnumerable<WorkoutViewModel>>>
{
  private readonly IWorkoutRepositoryAsync _workoutRepository;
  public GetWorkoutsQueryHandler(IWorkoutRepositoryAsync workoutRepository)
  {
    _workoutRepository = workoutRepository;
  }

  public async Task<PagedResponse<IEnumerable<WorkoutViewModel>>> Handle(GetWorkoutsQuery request, CancellationToken cancellationToken)
  {
    var validFilter = request.Adapt<RequestParameter>();
    var dataCount = await _workoutRepository.GetDataCountBySubjectId(request.SubjectId);
    var workouts = await _workoutRepository.GetBySubjectIdPagedAsync(request.SubjectId, request.PageSize, request.PageNumber);
    
    var workoutViewModels = new List<WorkoutViewModel>();

    foreach (var w in workouts)
    {
      var workout = w.Adapt<WorkoutViewModel>();
      workoutViewModels.Add(workout);
    }

    return new PagedResponse<IEnumerable<WorkoutViewModel>>(workoutViewModels, validFilter.PageNumber, validFilter.PageSize, dataCount);
  }
}

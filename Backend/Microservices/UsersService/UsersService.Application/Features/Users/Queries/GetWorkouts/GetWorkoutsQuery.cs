namespace UsersService.Application.Features.Users.Queries.GetAllUsers;

using UsersService.Application.Interfaces.Repositories;
using UsersService.Application.Features.SharedViewModels;
using Common.Wrappers;
using Common.Parameters;
using MediatR;
using Mapster;
using Common.Helpers;

public class GetWorkoutsQuery : IRequest<PagedResponse<IEnumerable<WorkoutViewModel>>>
{
  public int PageNumber { get; set; }
  public int PageSize { get; set; }
}

public class GetWorkoutsQueryHandler : IRequestHandler<GetWorkoutsQuery, PagedResponse<IEnumerable<WorkoutViewModel>>>
{
  private readonly IWorkoutRepositoryAsync _workoutRepository;
  private readonly IUserAccessor _userAccessor;
  public GetWorkoutsQueryHandler(IWorkoutRepositoryAsync workoutRepository, IUserAccessor userAccessor)
  {
    _workoutRepository = workoutRepository;
    _userAccessor = userAccessor;
  }

  public async Task<PagedResponse<IEnumerable<WorkoutViewModel>>> Handle(GetWorkoutsQuery request, CancellationToken cancellationToken)
  {

    var validFilter = request.Adapt<RequestParameter>();
    var dataCount = await _workoutRepository.GetDataCountBySubjectId(_userAccessor.SubjectId);
    var workouts = await _workoutRepository.GetBySubjectIdPagedAsync(_userAccessor.SubjectId, request.PageSize, request.PageNumber);
    
    var workoutViewModels = new List<WorkoutViewModel>();

    foreach (var w in workouts)
    {
      var workout = w.Adapt<WorkoutViewModel>();
      workoutViewModels.Add(workout);
    }

    return new PagedResponse<IEnumerable<WorkoutViewModel>>(workoutViewModels, validFilter.PageNumber, validFilter.PageSize, dataCount);
  }
}

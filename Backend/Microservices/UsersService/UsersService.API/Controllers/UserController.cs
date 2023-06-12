namespace UsersService.API.Controllers.v1;

using UsersService.Application.Features.Users.Commands;
using UsersService.Application.Features.Users.Queries.GetAllUsers;

using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Authorization;
using System.Security.Claims;
using UsersService.Application.Features.Users.Queries.GetTrainerBySubjectId;
using UsersService.Application.Features.Users.Queries.GetAllTrainers;
using UsersService.Application.Features.Users.Queries.GetEnrolledUsers;
using UsersService.Application.Features.Users.Queries.GetTraineeBySubjectId;

public class UserController : BaseApiController
{
  // POST api/<controller>
  [HttpPost]
  [Authorize]
  public async Task<IActionResult> Create()
  {
    return Ok(await Mediator.Send(new CreateUserCommand { SubjectId = User.FindFirstValue(ClaimTypes.NameIdentifier) }));
  }

  // POST api/<controller>
  [HttpPatch("UpdateMeasurements")]
  [Authorize]
  public async Task<IActionResult> UpdateMeasurements(UpdateUserMeasurementsCommand command)
  {
    command.SubjectId = User.FindFirstValue(ClaimTypes.NameIdentifier);
    return Ok(await Mediator.Send(command));
  }

  // POST api/<controller>
  [HttpPatch("UpdateDiet")]
  [Authorize]
  public async Task<IActionResult> UpdateDiet(UpdateUserDietCommand command)
  {
    return Ok(await Mediator.Send(command));
  }

  // POST api/<controller>
  [HttpPatch("UpdateAvatar")]
  [Authorize]
  public async Task<IActionResult> UpdateAvatar(UpdateUserAvatarCommand command)
  {
    return Ok(await Mediator.Send(command));
  }

  // POST api/<controller>
  [HttpPost("SwitchToTrainerAccountType")]
  [Authorize]
  public async Task<IActionResult> SwitchToTrainerAccountType()
  {
    return Ok(await Mediator.Send(new SwitchToTrainerAccountTypeCommand { SubjectId = User.FindFirstValue(ClaimTypes.NameIdentifier) }));
  }

  // GET: api/<controller>
  [HttpGet]
  [Authorize]
  public async Task<IActionResult> Get()
  {
    return Ok(await Mediator.Send(new GetUserQuery() { SubjectId = User.FindFirstValue(ClaimTypes.NameIdentifier) }));
  }

  // GET: api/<controller>
  [HttpGet("AllUsers")]
  [Authorize]
  public async Task<IActionResult> Get([FromQuery] GetAllUsersQuery query)
  {
    return Ok(await Mediator.Send(query));
  }

  // GET: api/<controller>
  [HttpGet("Trainer/{subjectId}")]
  [Authorize]
  public async Task<IActionResult> Get(string subjectId)
  {
    return Ok(await Mediator.Send(new GetTrainerBySubjectIdQuery() { SubjectId = subjectId}));
  }

  // GET: api/<controller>
  [HttpGet("Trainee/{subjectId}")]
  [Authorize]
  public async Task<IActionResult> GetTrainee(string subjectId)
  {
    return Ok(await Mediator.Send(new GetTraineeBySubjectIdQuery() { SubjectId = subjectId }));
  }

  // GET: api/<controller>
  [HttpGet("Trainer")]
  [Authorize]
  public async Task<IActionResult> Get([FromQuery] GetAllTrainersQuery query)
  {
    return Ok(await Mediator.Send(query));
  }

  // GET: api/<controller>
  [HttpGet("Trainer/GetEnrolledUsers")]
  [Authorize]
  public async Task<IActionResult> GetEnrolledUsers()
  {
    return Ok(await Mediator.Send(new GetEnrolledUsersQuery()));
  }

  [HttpPost("Workout")]
  [Authorize]
  public async Task<IActionResult> CreateWorkout(CreateWorkoutCommand command)
  {
    return Ok(await Mediator.Send(command));
  }

  [HttpDelete("Workout")]
  [Authorize]
  public async Task<IActionResult> DeleteWorkout(DeleteWorkoutCommand command)
  {
    return Ok(await Mediator.Send(command));
  }

  [HttpGet("Workout")]
  [Authorize]
  public async Task<IActionResult> GetWorkouts([FromQuery] GetWorkoutsQuery query)
  {
    return Ok(await Mediator.Send(query));
  }
}

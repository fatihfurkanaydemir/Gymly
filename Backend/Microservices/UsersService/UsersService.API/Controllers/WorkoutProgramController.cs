namespace UsersService.API.Controllers.v1;

using UsersService.Application.Features.Users.Commands;
using UsersService.Application.Features.Users.Queries.GetAllUsers;

using Microsoft.AspNetCore.Mvc;
using Common.Parameters;
using MassTransit;
using Common.Contracts.Entities;
using Microsoft.AspNetCore.Authorization;
using System.Security.Claims;

public class WorkoutProgramController : BaseApiController
{
  // POST api/<controller>
  [HttpPost("CreateUserWorkoutProgram")]
  [Authorize]
  public async Task<IActionResult> CreateUserWorkoutProgram(CreateUserWorkoutProgramCommand command)
  {
    command.SubjectId = User.FindFirstValue(ClaimTypes.NameIdentifier);
    return Ok(await Mediator.Send(command));
  }

  // POST api/<controller>
  [HttpDelete("DeleteUserWorkoutProgram")]
  [Authorize]
  public async Task<IActionResult> DeleteUserWorkoutProgram(DeleteUserWorkoutProgramCommand command)
  {
    command.SubjectId = User.FindFirstValue(ClaimTypes.NameIdentifier);
    return Ok(await Mediator.Send(command));
  }

  // POST api/<controller>
  [HttpPatch("UpdateUserWorkoutProgram")]
  [Authorize]
  public async Task<IActionResult> UpdateUserWorkoutProgram(UpdateUserWorkoutProgramCommand command)
  {
    command.SubjectId = User.FindFirstValue(ClaimTypes.NameIdentifier);
    return Ok(await Mediator.Send(command));
  }


  /// 
  /// ////////////////////////////////////////////////////////////////
  /// ////////////////////////////////////////////////////////////////
  /// 

  // POST api/<controller>
  [HttpPost("CreateTrainerWorkoutProgram")]
  [Authorize]
  public async Task<IActionResult> CreateTrainerWorkoutProgram(CreateTrainerWorkoutProgramCommand command)
  {
    command.SubjectId = User.FindFirstValue(ClaimTypes.NameIdentifier);
    return Ok(await Mediator.Send(command));
  }

  // POST api/<controller>
  [HttpDelete("DeleteTrainerWorkoutProgram")]
  [Authorize]
  public async Task<IActionResult> DeleteTrainerWorkoutProgram(DeleteTrainerWorkoutProgramCommand command)
  {
    command.SubjectId = User.FindFirstValue(ClaimTypes.NameIdentifier);
    return Ok(await Mediator.Send(command));
  }

  // POST api/<controller>
  [HttpPatch("UpdateTrainerWorkoutProgram")]
  [Authorize]
  public async Task<IActionResult> UpdateTrainerWorkoutProgram(UpdateTrainerWorkoutProgramCommand command)
  {
    command.SubjectId = User.FindFirstValue(ClaimTypes.NameIdentifier);
    return Ok(await Mediator.Send(command));
  }

  // POST api/<controller>
  [HttpPost("EnrollUserToProgram")]
  [Authorize]
  public async Task<IActionResult> EnrollUserToProgram(EnrollUserToProgramCommand command)
  {
    return Ok(await Mediator.Send(command));
  }

  // POST api/<controller>
  [HttpPost("CancelUserEnrollment")]
  [Authorize]
  public async Task<IActionResult> CancelUserEnrollment()
  {
    return Ok(await Mediator.Send(new CancelUserEnrollmentCommand()));
  }
}

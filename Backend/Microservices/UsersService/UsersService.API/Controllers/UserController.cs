﻿namespace UsersService.API.Controllers.v1;

using UsersService.Application.Features.Users.Commands;
using UsersService.Application.Features.Users.Queries.GetAllUsers;

using Microsoft.AspNetCore.Mvc;
using Common.Parameters;
using MassTransit;
using Common.Contracts.Entities;
using Microsoft.AspNetCore.Authorization;
using System.Security.Claims;

public class UserController : BaseApiController
{
  IRequestClient<GetEntityData> _client;
  public UserController(IRequestClient<GetEntityData> client)
  {
    _client = client;
  }

  // POST api/<controller>
  [HttpPost]
  [Authorize]
  public async Task<IActionResult> Create()
  {
    return Ok(await Mediator.Send(new CreateUserCommand { SubjectId = User.FindFirstValue(ClaimTypes.NameIdentifier) }));
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

  // GET: api/<controller>/TestGetEntityData/{id}
  [HttpGet("/api/TestGetEntityData/{id}")]
  //[Authorize(Policy = "IsAdmin")]
  public async Task<IActionResult> TestGetEntityData(int id)
  {
    return Ok(await _client.GetResponse<GetEntityDataResult>(new { Id = id }));
  }

  //// GET: api/<controller>
  //[HttpGet("Search")]
  //public async Task<IActionResult> GetBySearchFilter([FromQuery] GetUsersBySearchFilterParameter filter)
  //{
  //  return Ok(await Mediator.Send(new GetUsersBySearchFilterQuery() { FilterString = filter.FilterString, PageSize = filter.PageSize, PageNumber = filter.PageNumber }));
  //}

  //// GET: api/<controller>/id
  //[HttpGet("{id}")]
  //public async Task<IActionResult> GetById(int id)
  //{
  //  return Ok(await Mediator.Send(new GetUserByIdQuery() { Id = id }));
  //}

  //// PATCH: api/<controller>
  //[HttpPatch]
  //public async Task<IActionResult> Patch(UpdateUserCommand command)
  //{
  //  return Ok(await Mediator.Send(command));
  //}

  //// POST: api/<controller>/deactivate
  //[HttpPost("deactivate")]
  //public async Task<IActionResult> Deactivate(DeactivateUserCommand command)
  //{
  //  return Ok(await Mediator.Send(command));
  //}

  //// POST: api/<controller>/activate
  //[HttpPost("activate")]
  //public async Task<IActionResult> Activate(ActivateUserCommand command)
  //{
  //  return Ok(await Mediator.Send(command));
  //}
}

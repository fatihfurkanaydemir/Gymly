﻿namespace PostService.API.Controllers.v1;


using Microsoft.AspNetCore.Mvc;
using Common.Parameters;
using PostService.Application.Features.Posts.Commands;
using Microsoft.AspNetCore.Authorization;
using PostService.Application.Features.Posts.Queries.GetAllUsers;
using PostService.Application.Features.Posts.Queries.GetPostsBySubjectId;

public class PostController : BaseApiController
{
  // GET: api/<controller>
  [HttpPost]
  [Authorize]
  public async Task<IActionResult> Post(CreatePostCommand command)
  {
    return Ok(await Mediator.Send(command));
  }

  // GET: api/<controller>
  [HttpGet]
  [Authorize]
  public async Task<IActionResult> Get([FromQuery] RequestParameter filter)
  {
    return Ok(await Mediator.Send(new GetAllPostsQuery() { PageSize = filter.PageSize, PageNumber = filter.PageNumber }));
  }

  // GET: api/<controller>
  [HttpGet("GetUserPosts")]
  [Authorize]
  public async Task<IActionResult> GetUserPosts([FromQuery] GetPostsBySubjectIdQuery filter)
  {
    return Ok(await Mediator.Send(filter));
  }
}

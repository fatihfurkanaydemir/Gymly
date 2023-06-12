namespace PostService.API.Controllers.v1;


using Microsoft.AspNetCore.Mvc;
using Common.Parameters;
using PostService.Application.Features.Posts.Commands;
using Microsoft.AspNetCore.Authorization;
using PostService.Application.Features.Posts.Queries.GetAllUsers;
using PostService.Application.Features.Posts.Queries.GetPostsBySubjectId;
using PostService.Application.Features.Posts.Queries.GetPostById;
using PostService.Application.Features.TrainerNews.Commands;
using PostService.Application.Features.TrainerNews.Queries.GetTrainerNewsBySubjectId;

public class TrainerNewsController : BaseApiController
{
  // GET: api/<controller>
  [HttpPost]
  [Authorize]
  public async Task<IActionResult> Post(CreateTrainerNewsCommand command)
  {
    return Ok(await Mediator.Send(command));
  }

  // GET: api/<controller>
  [HttpDelete]
  [Authorize]
  public async Task<IActionResult> Delete(DeleteTrainerNewsCommand command)
  {
    return Ok(await Mediator.Send(command));
  }

  // GET: api/<controller>
  [HttpGet]
  [Authorize]
  public async Task<IActionResult> Get([FromQuery] GetTrainerNewsBySubjectIdQuery query)
  {
    return Ok(await Mediator.Send(query));
  }
}

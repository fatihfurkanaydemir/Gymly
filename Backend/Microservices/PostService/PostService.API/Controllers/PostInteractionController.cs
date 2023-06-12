namespace PostService.API.Controllers.v1;


using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Authorization;
using PostService.Application.Features.PostInteractions.Commands;
using PostService.Application.Features.PostInteractions.Queries.GetUserInteractions;

public class PostInteractionController : BaseApiController
{
  // GET: api/<controller>
  [HttpPost]
  [Authorize]
  public async Task<IActionResult> Interact(InteractWithPostCommand command)
  {
    return Ok(await Mediator.Send(command));
  }

  // GET: api/<controller>
  [HttpGet]
  [Authorize]
  public async Task<IActionResult> GetInteractions()
  {
    return Ok(await Mediator.Send(new GetUserInteractionsQuery()));
  }  
}

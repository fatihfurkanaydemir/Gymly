namespace ChatService.API.Controllers.v1;


using Microsoft.AspNetCore.Mvc;
using Common.Parameters;
using Microsoft.AspNetCore.Authorization;
using ChatService.Application.Features.Posts.Queries.GetChatHistory;

public class ChatHistoryController : BaseApiController
{
  // GET: api/<controller>
  [HttpGet]
  [Authorize]
  public async Task<IActionResult> Get([FromQuery] GetChatHistoryQuery query)
  {
    return Ok(await Mediator.Send(query));
  }
}

namespace ResourceService.API.Controllers.v1;


using Microsoft.AspNetCore.Mvc;
using Common.Parameters;
using ResourceService.API.Services;

public class ResourceController : BaseApiController
{
  FileUploaderService fileUploaderService;

  public ResourceController(FileUploaderService fileUploaderService)
  {
    this.fileUploaderService = fileUploaderService;
  }

  // POST api/<controller>
  [HttpPost("UploadImages")]
  public async Task<IActionResult> UploadImage(IFormFile[] files)
  {
    return Ok(await fileUploaderService.UploadImages(await Request.ReadFormAsync()));
  }
}

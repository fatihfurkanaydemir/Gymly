namespace ResourceService.API.Services;

using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Common.Exceptions;
using Common.Wrappers;

public class FileUploaderService
{
  IConfiguration _configuration;
  public FileUploaderService(IConfiguration config)
  {
    _configuration = config;
  }

  public async Task<Response<IList<string>>> UploadImages(IFormCollection formCollection)
  {
    var imagesPath = _configuration.GetSection("Directories").GetValue<string>("Images");
    var pathToSave = Path.Combine(Directory.GetCurrentDirectory(), imagesPath);

    var imagesToAdd = new List<string>();

    foreach (var file in formCollection.Files)
    {
      if (file.Length > 0)
      {
        var fileExtension = file.ContentType.Split("/")[1];

        var fileName = Guid.NewGuid().ToString() + "." + fileExtension;
        var fullPath = Path.Combine(pathToSave, fileName);
        var url = Path.Combine(imagesPath, fileName);
        using (var stream = new FileStream(fullPath, FileMode.Create))
        {
          await file.CopyToAsync(stream);
        }

        imagesToAdd.Add(url);
      }
      else
      {
        throw new ApiException("A problem occured with one of files");
      }
    }

    return new Response<IList<string>>
    {
      Data = imagesToAdd,
      Succeeded = true
    };
  }
}

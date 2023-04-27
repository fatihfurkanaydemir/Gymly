using PostService.Application;
using Common.Middlewares;
using Microsoft.AspNetCore.Http.Features;
using PostService.API.Extensions;
using PostService.Infrastructure.Persistence;
using MassTransit;
using PostService.Infrastructure.Persistence.Settings;
using PostService.Application.Helpers;
using Keycloak.AuthServices.Authentication;
using Keycloak.AuthServices.Authorization;

var builder = WebApplication.CreateBuilder(args);

var config = new ConfigurationBuilder()
  .AddJsonFile("appsettings.json")
  .Build();

builder.Services.AddControllers().ConfigureApiBehaviorOptions(options =>
{
  options.InvalidModelStateResponseFactory = actionContext =>
  {
    return Common.Wrappers.Response<string>.ModelValidationErrorResponse(actionContext);
  };
});

builder.Services.Configure<MongoDbSettings>(config.GetSection("MongoDbSettings"));
builder.Services.AddTransient<IUserAccessor, UserAccessor>();

builder.Services.AddApplicationLayer(config);
builder.Services.AddPersistenceInfrastructure(config);
builder.Services.AddSwaggerExtension();


builder.Services.AddCors(options =>
{
  options.AddDefaultPolicy(
    builder =>
    {
      builder.AllowAnyOrigin().AllowAnyHeader().AllowAnyMethod();
    });
});

builder.Services.Configure<FormOptions>(o =>
{
  o.ValueLengthLimit = int.MaxValue;
  o.MultipartBodyLengthLimit = int.MaxValue;
  o.MemoryBufferThreshold = int.MaxValue;
});

builder.Services.AddHealthChecks();
builder.Services.AddHttpContextAccessor();

builder.Services.AddKeycloakAuthentication(config);
builder.Services.AddAuthorization(o =>
{
  o.AddPolicy("IsAdmin", b =>
  {
    b.RequireRealmRoles("admin");
  });
});
builder.Services.AddKeycloakAuthorization(config);

var app = builder.Build();

//using (var scope = app.Services.CreateScope())
//{
//  var services = scope.ServiceProvider;

//  try
//  {
//    var entityRepository = services.GetRequiredService<IEntityRepositoryAsync>();

//    await DefaultEntities.SeedAsync(entityRepository);

//  }
//  catch (Exception ex)
//  {
//    Console.Error.WriteLine(ex);
//  }
//}

app.UseMiddleware<ErrorHandlerMiddleware>();

app.UseCors();
app.UseRouting();
app.UseSwagger();
app.UseSwaggerUI();
app.UseHealthChecks("/health");

//var folderName = Path.Combine("Resources", "Images");
//var pathToSave = Path.Combine(Directory.GetCurrentDirectory(), folderName);
//if (!Directory.Exists(pathToSave))
//  Directory.CreateDirectory(pathToSave);

app.UseDefaultFiles();
app.UseStaticFiles();
//app.UseStaticFiles(new StaticFileOptions()
//{
//  FileProvider = new PhysicalFileProvider(Path.Combine(Directory.GetCurrentDirectory(), "Resources")),
//  RequestPath = new PathString("/Resources")
//});

app.UseHttpsRedirection();
app.UseAuthentication();
app.UseAuthorization();
app.MapControllers();

app.Run();


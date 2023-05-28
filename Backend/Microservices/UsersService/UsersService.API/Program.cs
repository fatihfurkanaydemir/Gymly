using UsersService.Application;
using Common.Middlewares;
using Microsoft.AspNetCore.Http.Features;
using UsersService.API.Extensions;
using UsersService.Infrastructure.Persistence;
using UsersService.Application.Interfaces.Repositories;
using UsersService.Infrastructure.Persistence.Seeds;
using MassTransit;
using Keycloak.AuthServices.Authentication;
using Keycloak.AuthServices.Authorization;
using OtherService.Application.Features.Entities.Queries.GetEntity;
using Keycloak.AuthServices.Sdk.Admin;

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

builder.Services.AddApplicationLayer(config);
builder.Services.AddPersistenceInfrastructure(config);
builder.Services.AddSwaggerExtension();
builder.Services.AddRulesEngineExtension();

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

builder.Services.AddMassTransit(o =>
{
  o.AddConsumer<GetUserConsumer>();

  o.UsingRabbitMq((context, cfg) =>
  {
    cfg.Host("rabbitmq", "/", h =>
    {
      h.Username("admin");
      h.Password("admin");
    });

    cfg.UseNewtonsoftJsonSerializer();
    cfg.ConfigureEndpoints(context);
  });
});

builder.Services.AddOptions<MassTransitHostOptions>().Configure(options =>
{
  options.WaitUntilStarted = true;
  options.StartTimeout = TimeSpan.FromSeconds(10);
  options.StopTimeout = TimeSpan.FromSeconds(30);
});

builder.Services.AddKeycloakAuthentication(config);
builder.Services.AddAuthorization(o =>
{
  o.AddPolicy("IsAdmin", b =>
  {
    b.RequireRealmRoles("admin");
  });
});
builder.Services.AddKeycloakAuthorization(config);
builder.Services.AddKeycloakAdminHttpClient(config);
  
var app = builder.Build();

using (var scope = app.Services.CreateScope())
{
  var services = scope.ServiceProvider;

  try
  {
    var userRepository = services.GetRequiredService<IUserRepositoryAsync>();

    await DefaultUsers.SeedAsync(userRepository);

  }
  catch (Exception ex)
  {
    Console.Error.WriteLine(ex);
  }
}

app.UseMiddleware<ErrorHandlerMiddleware>();

app.UseCors();
app.UseRouting();
app.UseSwagger();
app.UseSwaggerUI();
app.UseHealthChecks("/health");

app.UseHttpsRedirection();
app.UseAuthentication();
app.UseAuthorization();
app.MapControllers();

app.Run();


using PostService.Application;
using Common.Middlewares;
using Microsoft.AspNetCore.Http.Features;
using PostService.API.Extensions;
using PostService.Infrastructure.Persistence;
using MassTransit;
using PostService.Infrastructure.Persistence.Settings;
using Keycloak.AuthServices.Authentication;
using Keycloak.AuthServices.Authorization;
using Common.Helpers;

var builder = WebApplication.CreateBuilder(args);

var config = new ConfigurationBuilder()
  .AddJsonFile("appsettings.json")
  .Build();

builder.Services.AddTransient<IUserAccessor, UserAccessor>();
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

builder.Services.AddMassTransit(o =>
{
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


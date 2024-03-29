using Ocelot.DependencyInjection;
using Ocelot.Middleware;

var builder = WebApplication.CreateBuilder(args);
builder.Configuration.SetBasePath(builder.Environment.ContentRootPath)
      .AddJsonFile($"appsettings.{builder.Environment.EnvironmentName}.json", true, true)
      .AddJsonFile("ocelot.json", optional: false, reloadOnChange: true)
      .AddEnvironmentVariables();

builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();

builder.Services.AddSwaggerGen(c =>
{
  c.ResolveConflictingActions(apiDescriptions => apiDescriptions.First());
  c.IgnoreObsoleteActions();
  c.IgnoreObsoleteProperties();
  c.CustomSchemaIds(type => type.FullName);
});

builder.Services.AddOcelot(builder.Configuration);
builder.Services.AddSwaggerForOcelot(builder.Configuration);

var app = builder.Build();

app.UseSwagger();
app.UseSwaggerForOcelotUI(opt => {
  opt.PathToSwaggerGenerator = "/swagger/docs";
});

app.UseCors(cors =>
{
  cors.AllowAnyHeader()
      .AllowAnyMethod()
      .SetIsOriginAllowed(x => true)
      .AllowCredentials();
});

app.UseHttpsRedirection();
app.UseAuthorization();
app.MapControllers();
app.UseWebSockets();
app.UseOcelot().Wait();

app.Run();
namespace PostService.Infrastructure.Persistence;

using PostService.Application.Interfaces.Repositories;
using PostService.Infrastructure.Persistence.Repositories;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using PostService.Infrastructure.Persistence.Settings;
using MongoDB.Driver;
using PostService.Domain.Entities;

public static class ServiceRegistration
{
  public static void AddPersistenceInfrastructure(this IServiceCollection services, IConfiguration configuration)
  {
    var settings = configuration.GetSection("MongoDbSettings").Get<MongoDbSettings>();
    var mongoClient = new MongoClient(settings.ConnectionString);
    var mongoDatabase = mongoClient.GetDatabase(settings.DatabaseName);

    services.AddSingleton(mongoDatabase.GetCollection<Post>(settings.PostCollectionName));
    services.AddSingleton(mongoDatabase.GetCollection<PostInteraction>(settings.PostInteractionCollectionName));
    services.AddSingleton(mongoDatabase.GetCollection<TrainerNews>(settings.TrainerNewsCollectionName));

    services.AddSingleton<IPostRepository, PostRepository>();
    services.AddSingleton<IPostInteractionRepository, PostInteractionRepository>();
    services.AddSingleton<ITrainerNewsRepository, TrainerNewsRepository>();
  }
}

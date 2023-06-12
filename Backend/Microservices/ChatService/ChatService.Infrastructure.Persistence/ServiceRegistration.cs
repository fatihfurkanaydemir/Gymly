namespace ChatService.Infrastructure.Persistence;

using ChatService.Application.Interfaces.Repositories;
using ChatService.Infrastructure.Persistence.Repositories;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using ChatService.Infrastructure.Persistence.Settings;
using MongoDB.Driver;
using ChatService.Domain.Entities;

public static class ServiceRegistration
{
  public static void AddPersistenceInfrastructure(this IServiceCollection services, IConfiguration configuration)
  {
    var settings = configuration.GetSection("MongoDbSettings").Get<MongoDbSettings>();
    var mongoClient = new MongoClient(settings.ConnectionString);
    var mongoDatabase = mongoClient.GetDatabase(settings.DatabaseName);

    services.AddSingleton(mongoDatabase.GetCollection<ChatMessage>(settings.ChatCollectionName));

    services.AddSingleton<IChatRepository, ChatRepository>();
  }
}

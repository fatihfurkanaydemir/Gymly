namespace UsersService.Infrastructure.Persistence.Seeds;

using UsersService.Application.Interfaces.Repositories;
using UsersService.Domain.Entities;
using Newtonsoft.Json;

public class DefaultUsers
{
  public static async Task<bool> SeedAsync(IUserRepositoryAsync userRepository)
  {
    //var mockData = File.ReadAllText(Path.Combine(
    //  Directory.GetCurrentDirectory(),
    //  @"SeedData/USER_MOCK_DATA.json"));

    //var deserializedMockData = JsonConvert.DeserializeObject<List<User>>(mockData);

    //var _item1 = deserializedMockData[0];

    var itemList = await userRepository.GetAllAsync();
    var _itemCount = itemList.Where(i => i.SubjectId.Equals("a83b7cce-ebb3-4835-b28f-91068f9c8919")).Count();

    if (_itemCount > 0) // ALREADY SEEDED
      return true;

    try
    {
      //foreach (var deserializedItem in deserializedMockData)
      //{
      //  await categoryRepository.AddAsync(deserializedItem);
      //}
      var User1 = new User()
      {
        SubjectId = "a83b7cce-ebb3-4835-b28f-91068f9c8919",
        Weight = 81,
        Height = 176,
        Type = Domain.Enums.UserType.Normal,
        Diet = "",
        Gender = "Male"
      };

      var User2 = new User()
      {
        SubjectId = "d32c9f45-7373-4f59-8547-83aeada47dfb",
        Weight = 60,
        Height = 168,
        Type = Domain.Enums.UserType.Normal,
        Diet = "",
        Gender = "Male"
      };

      var User3 = new User()
      {
        SubjectId = "73804339-35b0-4bc0-bedc-26d62ba2602e",
        Weight = 95,
        Height = 185,
        Type = Domain.Enums.UserType.Trainer,
        Diet = "",
        Gender = "Male"
      };

      var User4 = new User()
      {
        SubjectId = "d70f982d-334e-4500-b284-3369bace3480",
        Weight = 105,
        Height = 188,
        Type = Domain.Enums.UserType.Trainer,
        Diet = "",
        Gender = "Male"
      };

      await userRepository.AddAsync(User1);
      await userRepository.AddAsync(User2);
      await userRepository.AddAsync(User3);
      await userRepository.AddAsync(User4);
    }
    catch (Exception ex)
    {
      Console.WriteLine(ex.Message);
      throw;
    }

    return true; // NOT ALREADY SEEDED
  }
}

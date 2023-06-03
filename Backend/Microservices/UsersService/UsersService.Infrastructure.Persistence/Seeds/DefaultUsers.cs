namespace UsersService.Infrastructure.Persistence.Seeds;

using UsersService.Application.Interfaces.Repositories;
using UsersService.Domain.Entities;
using Newtonsoft.Json;

public class DefaultUsers
{
  public static async Task<bool> SeedAsync(IUserRepositoryAsync userRepository, ITrainerWorkoutProgramRepositoryAsync trainerWorkoutRepository)
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
      var User1 = new User()
      {
        SubjectId = "a83b7cce-ebb3-4835-b28f-91068f9c8919",
        Weight = 81,
        Height = 176,
        Type = Domain.Enums.UserType.Normal,
        Diet = "",
        Gender = "Male",
        AvatarUrl = ""
      };

      var User2 = new User()
      {
        SubjectId = "d32c9f45-7373-4f59-8547-83aeada47dfb",
        Weight = 60,
        Height = 168,
        Type = Domain.Enums.UserType.Normal,
        Diet = "",
        Gender = "Male",
        AvatarUrl = ""
      };

      var User3 = new User()
      {
        SubjectId = "73804339-35b0-4bc0-bedc-26d62ba2602e",
        Weight = 95,
        Height = 185,
        Type = Domain.Enums.UserType.Trainer,
        Diet = "",
        Gender = "Male",
        AvatarUrl = ""
      };

      var wp1 = new TrainerWorkoutProgram()
      {
        Description =
        "Ornare mauris.Pellentesque accumsan ex ac faucibus volutpat.Nunc vestibulum vel neque vel volutpat.Suspendisse molestie metus at est tempus," +
        "euismod porta odio fermentum.Sed id est erat.In porta orci lectus," +
        "et porta tortor tincidunt nec.",
        HeaderImageUrl = "Resources/Images/default_workout_program.jpg",
        Name = "Taylan Fit Summer Program",
        ProgramDetails = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer dignissim urna non felis bibendum, sit amet facilisis augue malesuada. Duis sagittis quis massa vitae ullamcorper. Duis fermentum nulla neque, et pellentesque tellus blandit et. Etiam nec enim at leo dictum lobortis. Sed eget tortor neque. Aliquam erat volutpat. Morbi sollicitudin tincidunt enim, vestibulum volutpat metus ullamcorper ut. Suspendisse pulvinar accumsan cursus. Fusce felis sem, porta ut pharetra nec, hendrerit vel eros.Pellentesque consequat efficitur scelerisque.Nullam viverra ex sed elementum mollis.Quisque nec lectus tellus.Donec vel blandit mauris," +
        "at ultricies nibh.Phasellus quis erat nec nibh consectetur euismod.Duis aliquet leo vitae urna porttitor, in eleifend massa feugiat.Aenean gravida quam et nibh consectetur efficitur.Vestibulum sit amet quam efficitur," +
        "mattis odio ac," +
        "egestas orci.Nulla vel turpis faucibus," +
        "ultrices velit quis," +
        "ornare mauris.Pellentesque accumsan ex ac faucibus volutpat.Nunc vestibulum vel neque vel volutpat.Suspendisse molestie metus at est tempus," +
        "euismod porta odio fermentum.Sed id est erat.In porta orci lectus," +
        "et porta tortor tincidunt nec.",
        Price = 1299,
        Title = "Your Workout for This Summer",
        TrainerSubjectId = "73804339-35b0-4bc0-bedc-26d62ba2602e"
      };

      var wp2 = new TrainerWorkoutProgram()
      {
        Description =
        "Ornare mauris.Pellentesque accumsan ex ac faucibus volutpat.Nunc vestibulum vel neque vel volutpat.Suspendisse molestie metus at est tempus," +
        "euismod porta odio fermentum.Sed id est erat.In porta orci lectus," +
        "et porta tortor tincidunt nec.",
        HeaderImageUrl = "Resources/Images/default_workout_program.jpg",
        Name = "Taylan Beginner Program",
        ProgramDetails = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer dignissim urna non felis bibendum, sit amet facilisis augue malesuada. Duis sagittis quis massa vitae ullamcorper. Duis fermentum nulla neque, et pellentesque tellus blandit et. Etiam nec enim at leo dictum lobortis. Sed eget tortor neque. Aliquam erat volutpat. Morbi sollicitudin tincidunt enim, vestibulum volutpat metus ullamcorper ut. Suspendisse pulvinar accumsan cursus. Fusce felis sem, porta ut pharetra nec, hendrerit vel eros.Pellentesque consequat efficitur scelerisque.Nullam viverra ex sed elementum mollis.Quisque nec lectus tellus.Donec vel blandit mauris," +
        "at ultricies nibh.Phasellus quis erat nec nibh consectetur euismod.Duis aliquet leo vitae urna porttitor, in eleifend massa feugiat.Aenean gravida quam et nibh consectetur efficitur.Vestibulum sit amet quam efficitur," +
        "mattis odio ac," +
        "egestas orci.Nulla vel turpis faucibus," +
        "ultrices velit quis," +
        "ornare mauris.Pellentesque accumsan ex ac faucibus volutpat.Nunc vestibulum vel neque vel volutpat.Suspendisse molestie metus at est tempus," +
        "euismod porta odio fermentum.Sed id est erat.In porta orci lectus," +
        "et porta tortor tincidunt nec.",
        Price = 1299,
        Title = "The best program you can find if you are an absolute beginner",
        TrainerSubjectId = "73804339-35b0-4bc0-bedc-26d62ba2602e"
      };

      var User4 = new User()
      {
        SubjectId = "d70f982d-334e-4500-b284-3369bace3480",
        Weight = 105,
        Height = 188,
        Type = Domain.Enums.UserType.Trainer,
        Diet = "",
        Gender = "Male",
        AvatarUrl = ""
      };

      var dbWp1 = await trainerWorkoutRepository.AddAsync(wp1);
      var dbWp2 = await trainerWorkoutRepository.AddAsync(wp2);
      User3.TrainerWorkoutPrograms.Add(dbWp1);
      User3.TrainerWorkoutPrograms.Add(dbWp2);

      User1.EnrolledProgram = dbWp1;

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

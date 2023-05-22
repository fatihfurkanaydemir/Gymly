namespace Common.Contracts;

public class GetUserContractResult
{
  public double Weight { get; set; } = default!;
  public double Height { get; set; } = default!;
  public string Gender { get; set; } = default!;
  public string AvatarUrl { get; set; } = default!;
  public string FirstName { get; set; } = default!;
  public string LastName { get; set; } = default!;
}

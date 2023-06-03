namespace ChatService.Application.Features.SharedViewModels;

public class ChatMessageViewModel
{
  public string Id { get; set; } = default!;

  public string SenderId { get; set; } = default!;

  public string ReceiverId { get; set; } = default!;

  public string Message { get; set; } = default!;

  public DateTime MessageTime { get; set; } = default!;
}

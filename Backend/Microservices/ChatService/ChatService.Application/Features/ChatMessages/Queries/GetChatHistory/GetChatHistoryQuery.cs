namespace ChatService.Application.Features.Posts.Queries.GetChatHistory;

using ChatService.Application.Interfaces.Repositories;
using ChatService.Application.Features.SharedViewModels;
using Common.Wrappers;
using Common.Parameters;
using MediatR;
using Mapster;
using Common.Helpers;
using System.ComponentModel.DataAnnotations;

public class GetChatHistoryQuery : IRequest<PagedResponse<IEnumerable<ChatMessageViewModel>>>
{
  [Required]
  public string OtherUserId { get; set; }
  public int PageNumber { get; set; }
  public int PageSize { get; set; }
}

public class GetChatHistoryQueryHandler : IRequestHandler<GetChatHistoryQuery, PagedResponse<IEnumerable<ChatMessageViewModel>>>
{
  private readonly IChatRepository _chatRepository;
  private readonly IUserAccessor _userAccessor;
  public GetChatHistoryQueryHandler(IChatRepository chatRepository, IUserAccessor userAccessor)
  {
    _chatRepository = chatRepository;
    _userAccessor = userAccessor;
  }

  public async Task<PagedResponse<IEnumerable<ChatMessageViewModel>>> Handle(GetChatHistoryQuery request, CancellationToken cancellationToken)
  {

    var validFilter = request.Adapt<RequestParameter>();
    var dataCount = await _chatRepository.GetDataCount(_userAccessor.SubjectId, request.OtherUserId);
    var messages = await _chatRepository.GetPagedReponseAsync(_userAccessor.SubjectId, request.OtherUserId, request.PageNumber, request.PageSize);

    var msgViewModels = new List<ChatMessageViewModel>();

    foreach (var p in messages)
    {
      var msgViewModel = p.Adapt<ChatMessageViewModel>();
      msgViewModels.Add(msgViewModel);
    }

    return new PagedResponse<IEnumerable<ChatMessageViewModel>>(msgViewModels, validFilter.PageNumber, validFilter.PageSize, dataCount);
  }
}

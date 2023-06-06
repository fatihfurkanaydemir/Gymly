using PostService.Domain.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PostService.Application.Interfaces.Repositories;

public interface IPostInteractionRepository
{
  Task<IReadOnlyList<PostInteraction>> GetInteractionsOfUser(string subjectId);
  Task<PostInteraction> GetByIdAsync(string id);
  Task<PostInteraction> GetByPostAndSubjectIdAsync(string postId, string subjectId);
  Task RemoveAllInteractionsOfPostAsync(string postId);
  Task AddAsync(PostInteraction post);
  Task RemoveAsync(string id);
  Task UpdateAsync(string id, PostInteraction post);
}

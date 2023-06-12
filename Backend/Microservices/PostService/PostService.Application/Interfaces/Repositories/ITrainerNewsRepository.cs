using PostService.Domain.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PostService.Application.Interfaces.Repositories;

public interface ITrainerNewsRepository
{
  Task<IReadOnlyList<TrainerNews>> GetPagedReponseBySubjectIdAsync(string subjectId, int pageNumber, int pageSize);
  Task<int> GetDataCountBySubjectId(string subjectId);
  Task<TrainerNews> GetByIdAsync(string id);
  Task AddAsync(TrainerNews TrainerNews);
  Task RemoveAsync(string id);
  Task UpdateAsync(string id, TrainerNews TrainerNews);
}

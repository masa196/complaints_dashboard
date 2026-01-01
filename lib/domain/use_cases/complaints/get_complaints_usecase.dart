
import '../../../data/models/pagination_result.dart';
import '../../entities/compaints/complaint.dart';
import '../../repository/complaints/base_complaints_repo.dart';

class GetComplaintsUseCase {
  final BaseComplaintsRepository repository;

  GetComplaintsUseCase(this.repository);

  Future<PaginationResult<Complaint>> execute({int page = 1}) {
    return repository.getAgencyComplaints(page: page);
  }
}

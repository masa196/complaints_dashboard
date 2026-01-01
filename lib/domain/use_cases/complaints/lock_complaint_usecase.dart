
import '../../repository/complaints/base_complaints_repo.dart';

class LockComplaintUseCase {
  final BaseComplaintsRepository repo;
  LockComplaintUseCase(this.repo);

  Future<Map<String, dynamic>> execute(int id) {
    return repo.lockComplaint(id);
  }
}

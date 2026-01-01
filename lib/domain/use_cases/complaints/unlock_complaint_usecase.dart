// lib/employee_dashboard/domain/use_cases/unlock_complaint_usecase.dart
import '../../../data/repository/complaints/complaints_repository.dart';
import '../../../domain/repository/complaints/base_complaints_repo.dart';

class UnlockComplaintUseCase {
  final BaseComplaintsRepository repo;
  UnlockComplaintUseCase(this.repo);

  Future<Map<String, dynamic>> execute(int id) {
    return repo.unlockComplaint(id);
  }
}

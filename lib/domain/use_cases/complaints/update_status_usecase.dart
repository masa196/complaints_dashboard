// lib/employee_dashboard/domain/use_cases/update_status_usecase.dart
import '../../../data/repository/complaints/complaints_repository.dart';
import '../../repository/complaints/base_complaints_repo.dart';

class UpdateStatusUseCase {
  final BaseComplaintsRepository repo;
  UpdateStatusUseCase(this.repo);

  Future<Map<String, dynamic>> execute(int id, String status) {
    return repo.updateStatus(id, status);
  }
}

// lib/employee_dashboard/domain/use_cases/request_info_usecase.dart
import '../../../data/repository/complaints/complaints_repository.dart';
import '../../repository/complaints/base_complaints_repo.dart';

class RequestInfoUseCase {
  final BaseComplaintsRepository repo;
  RequestInfoUseCase(this.repo);

  Future<Map<String, dynamic>> execute(int id, String requestText) {
    return repo.requestInfo(id, requestText);
  }
}

import 'package:dartz/dartz.dart';
import '../../../core/error/failure.dart';
import '../../../data/models/audit_log/audit_log_model.dart';
import '../../repository/audit_logs/base_audit_repository.dart';

class GetAuditLogsUseCase {
  final BaseAuditRepository repository;
  GetAuditLogsUseCase(this.repository);

  Future<Either<Failure, AuditResponseModel>> call(int page) async {
    return await repository.getAuditLogs(page);
  }
}
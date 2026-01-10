import 'package:dartz/dartz.dart';
import '../../../core/error/failure.dart';
import '../../../data/models/audit_log/audit_log_model.dart';

abstract class BaseAuditRepository {
  Future<Either<Failure, AuditResponseModel>> getAuditLogs(int page);
}
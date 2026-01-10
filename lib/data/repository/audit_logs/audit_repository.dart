import 'package:dartz/dartz.dart';
import '../../../core/error/exceptions.dart';
import '../../../core/error/failure.dart';
import '../../../domain/repository/audit_logs/base_audit_repository.dart';
import '../../dataSource/audit_logs/audit_remote_data_source.dart';
import '../../models/audit_log/audit_log_model.dart';

class AuditRepository implements BaseAuditRepository {
  final BaseAuditRemoteDataSource remoteDataSource;
  AuditRepository(this.remoteDataSource);

  @override
  Future<Either<Failure, AuditResponseModel>> getAuditLogs(int page) async {
    try {
      final result = await remoteDataSource.getAuditLogs(page);
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.userFriendlyMessage()));
    } catch (e) {
      return Left(ServerFailure("حدث خطأ في البيانات: ${e.toString()}"));
    }
  }
}
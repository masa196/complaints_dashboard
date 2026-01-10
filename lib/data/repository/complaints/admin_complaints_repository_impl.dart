
import 'package:dartz/dartz.dart';
import '../../../core/error/exceptions.dart';
import '../../../core/error/failure.dart';
import '../../../domain/repository/complaints/base_admin_complaints_repository.dart';
import '../../dataSource/complaints/admin_complaints_remote_data_source.dart';
import '../../models/complaint_for_admin/complaints_for_admin_model.dart';

class AdminComplaintsRepositoryImpl implements BaseAdminComplaintsRepository {
  final AdminComplaintsRemoteDataSource remoteDataSource;

  AdminComplaintsRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<DatumForAdmin>>> getAllComplaints() async {
    try {
      final result = await remoteDataSource.getComplaints();
      return Right(result.data ?? []);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.userFriendlyMessage()));
    } catch (e) {
      return Left(ServerFailure("حدث خطأ غير متوقع: ${e.toString()}"));
    }
  }

  @override
  Future<Either<Failure, List<DatumForAdmin>>> getComplaintsByStatus(String status) async {
    try {
      final result = await remoteDataSource.getComplaints(status: status);
      return Right(result.data ?? []);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.errorMessageModel.userFriendlyMessage()));
    } catch (e) {
      return Left(ServerFailure("حدث خطأ في تصفية البيانات: ${e.toString()}"));
    }
  }
}
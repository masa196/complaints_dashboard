// lib/employee_dashboard/data/repository/complaints_repository.dart
import 'package:dartz/dartz.dart';
import '../../../core/error/exceptions.dart';
import '../../../core/error/failure.dart';
import '../../../domain/entities/compaints/complaint.dart';
import '../../../domain/repository/complaints/base_complaints_repo.dart';
import '../../dataSource/complaints/complaints_remote_data_source.dart';
import '../../models/complaints/complaint_model.dart';
import '../../models/pagination_result.dart';

class ComplaintsRepository implements BaseComplaintsRepository {
  final BaseComplaintsRemoteDataSource remote;

  ComplaintsRepository(this.remote);

  @override
  Future<Either<Failure, PaginationResult<Complaint>>> getAgencyComplaints({int page = 1}) async {
    try {
      final map = await remote.fetchAgencyComplaints(page: page);

      final data = Map<String, dynamic>.from(map['data']);
      final List<Complaint> complaints = (data['data'] as List)
          .map((e) => ComplaintModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();

      return Right(PaginationResult<Complaint>(
        data: complaints,
        currentPage: data['current_page'],
        lastPage: data['last_page'],
      ));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.errorMessageModel.userFriendlyMessage()));
    } catch (e) {
      return Left(ServerFailure("حدث خطأ غير متوقع أثناء جلب الشكاوى"));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> lockComplaint(int id) async {
    try {
      final result = await remote.lockComplaint(id);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.errorMessageModel.userFriendlyMessage()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> updateStatus(int id, String status) async {
    try {
      final result = await remote.updateStatus(id, status);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.errorMessageModel.userFriendlyMessage()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> requestInfo(int id, String requestText) async {
    try {
      final result = await remote.requestInfo(id, requestText);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.errorMessageModel.userFriendlyMessage()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> unlockComplaint(int id) async {
    try {
      final result = await remote.unlockComplaint(id);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.errorMessageModel.userFriendlyMessage()));
    }
  }
}
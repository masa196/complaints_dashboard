// lib/employee_dashboard/domain/repository/complaints/base_complaints_repo.dart
import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../../data/models/pagination_result.dart';
import '../../entities/compaints/complaint.dart';

abstract class BaseComplaintsRepository {

  Future<Either<Failure, PaginationResult<Complaint>>> getAgencyComplaints({int page = 1});

  Future<Either<Failure, Map<String, dynamic>>> lockComplaint(int id);

  Future<Either<Failure, Map<String, dynamic>>> updateStatus(int id, String status);

  Future<Either<Failure, Map<String, dynamic>>> requestInfo(int id, String requestText);

  Future<Either<Failure, Map<String, dynamic>>> unlockComplaint(int id);
}
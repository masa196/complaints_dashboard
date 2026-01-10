
import 'package:dartz/dartz.dart';
import '../../../core/error/failure.dart';
import '../../../data/models/complaint_for_admin/complaints_for_admin_model.dart';

abstract class BaseAdminComplaintsRepository {
  Future<Either<Failure, List<DatumForAdmin>>> getAllComplaints();
  Future<Either<Failure, List<DatumForAdmin>>> getComplaintsByStatus(String status);
}
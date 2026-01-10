import 'package:dartz/dartz.dart';

import '../../../core/error/failure.dart';
import '../../../data/models/complaint_for_admin/complaints_for_admin_model.dart';
import '../../repository/complaints/base_admin_complaints_repository.dart';

class GetAdminComplaintsUseCase {
  final BaseAdminComplaintsRepository repository;
  GetAdminComplaintsUseCase(this.repository);

  Future<Either<Failure, List<DatumForAdmin>>> execute({String? status}) {
    if (status == null || status == "all") {
      return repository.getAllComplaints();
    } else {
      return repository.getComplaintsByStatus(status);
    }
  }
}
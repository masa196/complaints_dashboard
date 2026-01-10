import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../repository/complaints/base_complaints_repo.dart';

class UnlockComplaintUseCase {
  final BaseComplaintsRepository repo;
  UnlockComplaintUseCase(this.repo);

  Future<Either<Failure, Map<String, dynamic>>> execute(int id) {
    return repo.unlockComplaint(id);
  }
}
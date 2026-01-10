import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../repository/complaints/base_complaints_repo.dart';

class UpdateStatusUseCase {
  final BaseComplaintsRepository repo;
  UpdateStatusUseCase(this.repo);

  Future<Either<Failure, Map<String, dynamic>>> execute(int id, String status) {
    return repo.updateStatus(id, status);
  }
}
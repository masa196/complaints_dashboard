import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../repository/complaints/base_complaints_repo.dart';

class RequestInfoUseCase {
  final BaseComplaintsRepository repo;
  RequestInfoUseCase(this.repo);

  Future<Either<Failure, Map<String, dynamic>>> execute(int id, String requestText) {
    return repo.requestInfo(id, requestText);
  }
}

import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../data/models/roles/roles_model.dart';
import '../../repository/roles/roles_base_repository.dart';




class GetRolesUseCase  {
  final RolesBaseRepository repository;

  const GetRolesUseCase(this.repository);

  Future<Either<Failure, List<Role>>> call() {
    return repository.getRoles();
  }
}

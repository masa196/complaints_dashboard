
import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../data/models/permissions/all_permissions_model.dart';
import '../../repository/roles/roles_base_repository.dart';




class GetPermissionsDetailsUseCase  {
  final RolesBaseRepository repository;

  const GetPermissionsDetailsUseCase(this.repository);

  Future<Either<Failure, AllPermissionsModel>> call() {
    return repository.getAllPermissions();
  }
}

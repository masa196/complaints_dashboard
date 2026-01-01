
import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../repository/roles/roles_base_repository.dart';



class UpdateRolePermissionsUseCase {
  final RolesBaseRepository repository;

  UpdateRolePermissionsUseCase(this.repository);

  Future<Either<Failure, Unit>> call(int roleId, List<String> permissions,) async {
    return repository.updateRolePermissions(roleId, permissions);
  }
}

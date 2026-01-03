import 'package:dartz/dartz.dart';
import '../../../core/error/failure.dart';
import '../../entities/employees/assign_remove_role_entity.dart';
import '../../repository/roles/roles_base_repository.dart';

class RemoveRoleUseCase {
  final RolesBaseRepository repository;

  RemoveRoleUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call( AssignRemoveRoleEntity data) {
    return repository.removeRole(data);
  }
}

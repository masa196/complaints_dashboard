import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../repository/roles/roles_base_repository.dart';


class DeleteRoleUseCase {
  final RolesBaseRepository repository;

  DeleteRoleUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(int roleId) {
    return repository.deleteRole(roleId);
  }
}

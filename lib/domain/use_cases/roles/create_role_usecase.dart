
import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../entities/roles/create_role_entity.dart';
import '../../repository/roles/roles_base_repository.dart';



class CreateRoleUseCase  {
  final RolesBaseRepository repository;

  CreateRoleUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(CreateRoleEntity data) {
    return repository.createRole(data);
  }
}

import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../data/models/roles/role_model.dart';
import '../../repository/roles/roles_base_repository.dart';




class GetRoleDetailsUseCase  {
  final RolesBaseRepository repository;

  GetRoleDetailsUseCase(this.repository);

  @override
  Future<Either<Failure, RoleModel>> call(int roleId) {
    return repository.getRoleDetails(roleId);
  }
}

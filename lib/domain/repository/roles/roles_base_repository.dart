
import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../../data/models/permissions/all_permissions_model.dart';
import '../../../data/models/roles/role_model.dart';
import '../../../data/models/roles/roles_model.dart';
import '../../entities/employees/assign_remove_role_entity.dart';
import '../../entities/roles/create_role_entity.dart';

abstract class RolesBaseRepository {
  Future<Either<Failure,List<Role>>> getRoles();
  Future<Either<Failure,RoleModel>> getRoleDetails(int id);
  Future<Either<Failure,AllPermissionsModel>> getAllPermissions();
  Future<Either<Failure, Unit>> createRole(CreateRoleEntity params);
  Future<Either<Failure, Unit>> updateRolePermissions(int roleId, List<String> permissions);
  Future<Either<Failure, Unit>> deleteRole(int roleId);
  Future<Either<Failure, Unit>> assignRole(AssignRemoveRoleEntity params);
  Future<Either<Failure, Unit>> removeRole(AssignRemoveRoleEntity params);
}
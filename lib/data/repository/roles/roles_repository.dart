

import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failure.dart';
import '../../../domain/entities/roles/create_role_entity.dart';
import '../../../domain/repository/roles/roles_base_repository.dart';
import '../../dataSource/roles/roles_remote_data_source.dart';
import '../../models/permissions/all_permissions_model.dart';
import '../../models/roles/role_model.dart';
import '../../models/roles/roles_model.dart';


class RolesRepository extends RolesBaseRepository {
  final BaseRolesRemoteDataSource remote;

  RolesRepository(this.remote);


  @override
  Future<Either<Failure, List<Role>>> getRoles() async {
    try {
      final result = await remote.getRoles();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.errorMessageModel.userFriendlyMessage()));
    }
  }



  @override
  Future<Either<Failure, AllPermissionsModel>> getAllPermissions() async {
    try {
      final result = await remote.getAllPermissions();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.errorMessageModel.userFriendlyMessage()));
    }
  }

  @override
  Future<Either<Failure, RoleModel>> getRoleDetails(int id) async {
    try {
      final result = await remote.getRoleDetails(id);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.errorMessageModel.userFriendlyMessage()));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateRolePermissions(
      int roleId, List<String> permissions) async {
    try {
      await remote.updateRolePermissions(roleId, permissions);
      return const Right(unit);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.errorMessageModel.userFriendlyMessage()));
    }
  }

  @override
  Future<Either<Failure, Unit>> createRole(CreateRoleEntity params) async {
    try {
      await remote.createRole(params);
      return const Right(unit);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.errorMessageModel.userFriendlyMessage()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteRole(int roleId) async {
    try {
      await remote.deleteRole(roleId);
      return const Right(unit);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.errorMessageModel.userFriendlyMessage()));
    }
  }
}
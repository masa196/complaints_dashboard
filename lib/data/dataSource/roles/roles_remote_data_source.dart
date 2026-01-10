import 'package:dio/dio.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/error_message_model.dart';
import '../../../../core/utils/AuthInterceptor.dart';
import '../../../domain/entities/employees/assign_remove_role_entity.dart';
import '../../../domain/entities/roles/create_role_entity.dart';
import '../../models/permissions/all_permissions_model.dart';
import '../../models/roles/role_model.dart';
import '../../models/roles/roles_model.dart';
import '../../../../core/constants/api_constants.dart';

abstract class BaseRolesRemoteDataSource {
  Future<List<Role>> getRoles();
  Future<RoleModel> getRoleDetails(int roleId);
  Future<AllPermissionsModel> getAllPermissions();
  Future<void> createRole(CreateRoleEntity entity);
  Future<void> updateRolePermissions(int roleId, List<String> permissions);
  Future<void> deleteRole(int roleId);
  Future<void> assignRole(AssignRemoveRoleEntity params);
  Future<void> removeRole(AssignRemoveRoleEntity params);
}

class RolesRemoteDataSource extends BaseRolesRemoteDataSource {
  final Dio dio;

  RolesRemoteDataSource({Dio? dio})
      : dio = dio ?? Dio(BaseOptions(baseUrl: ApiConstants.baseUrl)) {
    this.dio.interceptors.add(AuthInterceptor());
    this.dio.options.headers.addAll({
      'Accept': 'application/json',
      'X-Requested-With': 'XMLHttpRequest',
    });
    this.dio.options.validateStatus = (status) => true;
  }

  dynamic _processResponse(Response response) {
    if (response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300) {
      if (response.data is Map) return response.data;
    }
    throw ServerException(errorMessageModel: ErrorMessageModel.handleResponse(response));
  }

  @override
  Future<List<Role>> getRoles() async {
    try {
      final response = await dio.get('/api/admin/roles');
      final data = _processResponse(response);
      return RolesModel.fromJson(data).data ?? [];
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(errorMessageModel: ErrorMessageModel.fromDioError(e));
    }
  }

  @override
  Future<AllPermissionsModel> getAllPermissions() async {
    try {
      final response = await dio.get('/api/admin/permissions');
      final data = _processResponse(response);
      return AllPermissionsModel.fromJson(data);
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(errorMessageModel: ErrorMessageModel.fromDioError(e));
    }
  }

  @override
  Future<void> createRole(CreateRoleEntity entity) async {
    try {
      final response = await dio.post('/api/admin/roles', data: entity.toJson());
      _processResponse(response);
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(errorMessageModel: ErrorMessageModel.fromDioError(e));
    }
  }

  @override
  Future<RoleModel> getRoleDetails(int roleId) async {
    try {
      final response = await dio.get('/api/admin/roles/$roleId');
      final data = _processResponse(response);
      return RoleModel.fromJson(data);
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(errorMessageModel: ErrorMessageModel.fromDioError(e));
    }
  }

  @override
  Future<void> updateRolePermissions(int roleId, List<String> permissions) async {
    try {
      final response = await dio.put('/api/admin/roles/$roleId/permissions', data: {'permissions': permissions});
      _processResponse(response);
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(errorMessageModel: ErrorMessageModel.fromDioError(e));
    }
  }

  @override
  Future<void> deleteRole(int roleId) async {
    try {
      final response = await dio.delete('/api/admin/roles/$roleId');
      _processResponse(response);
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(errorMessageModel: ErrorMessageModel.fromDioError(e));
    }
  }

  @override
  Future<void> assignRole(AssignRemoveRoleEntity params) async {
    try {
      final response = await dio.post('/api/admin/users/${params.employeeId}/assign-role', data: {'role': params.role});
      _processResponse(response);
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(errorMessageModel: ErrorMessageModel.fromDioError(e));
    }
  }

  @override
  Future<void> removeRole(AssignRemoveRoleEntity params) async {
    try {
      final response = await dio.post('/api/admin/users/${params.employeeId}/remove-role', data: {'role': params.role});
      _processResponse(response);
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(errorMessageModel: ErrorMessageModel.fromDioError(e));
    }
  }
}
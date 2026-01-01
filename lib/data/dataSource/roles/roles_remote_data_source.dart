
import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/error_message_model.dart';
import '../../../../core/utils/AuthInterceptor.dart';
import '../../../domain/entities/roles/create_role_entity.dart';
import '../../models/permissions/all_permissions_model.dart';
import '../../models/roles/role_model.dart';
import '../../models/roles/roles_model.dart';


abstract class BaseRolesRemoteDataSource {
  Future<List<Role>> getRoles();
  Future<RoleModel> getRoleDetails(int roleId);
  Future<AllPermissionsModel> getAllPermissions();
  Future<void> createRole(CreateRoleEntity params);
  Future<void> updateRolePermissions(int roleId, List<String> permissions);
  Future<void> deleteRole(int roleId);
}

class RolesRemoteDataSource extends BaseRolesRemoteDataSource {
  final Dio dio;


  RolesRemoteDataSource({Dio? dio})
      : dio = dio ?? Dio(BaseOptions(
    baseUrl: ApiConstants.baseUrl,

  )) {
    this.dio.interceptors.add(AuthInterceptor());
    this.dio.options.validateStatus = (status) => true;
  }

  @override
  Future<List<Role>> getRoles() async {
    print('🔹 Fetching roles...');
    final response = await dio.get(
      '${ApiConstants.baseUrl}/api/admin/roles',
      options: Options(responseType: ResponseType.json),
    );

    if (response.statusCode == 200) {
      final rolesModel = RolesModel.fromJson(response.data);
      return rolesModel.data ?? [];
    } else {
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(Map<String, dynamic>.from(response.data)),
      );
    }
  }


  @override
  Future<AllPermissionsModel> getAllPermissions() async {
    final response = await dio.get(
      '${ApiConstants.baseUrl}/api/admin/permissions',
      options: Options(responseType: ResponseType.json),
    );
    if (response.statusCode == 200) {
      final permissions = AllPermissionsModel.fromJson(response.data);
      return permissions;
    } else {
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(Map<String, dynamic>.from(response.data)),
      );
    }
  }

  @override
  Future<void> createRole(CreateRoleEntity entity) async {
    final response = await dio.post(
      '${ApiConstants.baseUrl}/api/admin/roles',
      data: entity.toJson(),
      options: Options(responseType: ResponseType.json),
    );

    if (response.statusCode != 200) {
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(Map<String, dynamic>.from(response.data)),
      );
    }
  }


  @override
  Future<RoleModel> getRoleDetails(int roleId) async {
    print('🔹 Fetching roles details for roleId: $roleId...');
    final response = await dio.get(
      '${ApiConstants.baseUrl}/api/admin/roles/$roleId',
      options: Options(responseType: ResponseType.json),
    );

    if (response.statusCode == 200) {
      final roleModel = RoleModel.fromJson(response.data);
      return roleModel;
    } else {
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(Map<String, dynamic>.from(response.data)),
      );
    }
  }

  @override
  Future<void> updateRolePermissions(int roleId, List<String> permissions,) async {
    final response = await dio.put(
      '${ApiConstants.baseUrl}/api/admin/roles/$roleId/permissions',
      data: {'permissions': permissions},
      options: Options(responseType: ResponseType.json),
    );
    if ( response.statusCode != 200) {
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(
          response.data is Map<String, dynamic>
              ? response.data
              : {
            'message': 'Unknown error',
            'errors': {},
          },
        ),
      );
    }

  }


  @override
  Future<void> deleteRole(int roleId) async {
    final response = await dio.delete(
      '${ApiConstants.baseUrl}/api/admin/roles/$roleId',
      options: Options(responseType: ResponseType.json),
    );

    if (response.statusCode != 200) {
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(response.data),
      );
    }
  }


}

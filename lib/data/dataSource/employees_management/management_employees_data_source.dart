import 'package:dio/dio.dart';
import 'package:untitled/data/models/employees/paginated_employees_model.dart';
import 'package:untitled/domain/entities/employees/update_employee_entity.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/error/exceptions.dart';
import '../../../core/network/error_message_model.dart';
import '../../../core/utils/AuthInterceptor.dart';


abstract class BaseManagementEmployeesDataSource {
  Future<PaginatedEmployeesModel> getEmployees (int page);
  Future<void> deleteEmployee(int userId);
  Future<void> updateEmployee(UpdateEmployeeEntity entity);

}

class ManagementEmployeesDataSource extends BaseManagementEmployeesDataSource {
  final Dio dio;


  ManagementEmployeesDataSource({Dio? dio})
      : dio = dio ?? Dio(BaseOptions(
    baseUrl: ApiConstants.baseUrl,

  )) {
    this.dio.interceptors.add(AuthInterceptor());
    this.dio.options.validateStatus = (status) => true;
  }

  @override
  Future<PaginatedEmployeesModel> getEmployees(int page) async {
    final response = await dio.get(
      '${ApiConstants.baseUrl}/api/admin/Employees?page=$page',
      options: Options(responseType: ResponseType.json),
    );

    if (response.statusCode == 200) {
      return PaginatedEmployeesModel.fromJson(response.data['data']);
    } else {
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(Map<String, dynamic>.from(response.data)),
      );
    }
  }

  @override
  Future<void> deleteEmployee(int employeeId) async {
    final response = await dio.delete(
      '${ApiConstants.baseUrl}/api/admin/Employees/$employeeId',
      options: Options(responseType: ResponseType.json),
    );

    if (response.statusCode != 200) {
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(Map<String, dynamic>.from(response.data)),
      );
    }
  }

  @override
  Future<void> updateEmployee(UpdateEmployeeEntity entity) async {
    final response = await dio.put(
      '${ApiConstants.baseUrl}/api/admin/Employees/${entity.id}',
      data: entity.toJson(),
      options: Options(responseType: ResponseType.json),
    );

    if (response.statusCode != 200) {
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(Map<String, dynamic>.from(response.data)),
      );
    }
  }
}

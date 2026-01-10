import 'package:dio/dio.dart';
import '../../models/employees/paginated_employees_model.dart';
import '../../../domain/entities/employees/update_employee_entity.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/error/exceptions.dart';
import '../../../core/network/error_message_model.dart';
import '../../../core/utils/AuthInterceptor.dart';

abstract class BaseManagementEmployeesDataSource {
  Future<PaginatedEmployeesModel> getEmployees(int page);
  Future<void> deleteEmployee(int userId);
  Future<void> updateEmployee(UpdateEmployeeEntity entity);
}

class ManagementEmployeesDataSource extends BaseManagementEmployeesDataSource {
  final Dio dio;

  ManagementEmployeesDataSource({Dio? dio})
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
  Future<PaginatedEmployeesModel> getEmployees(int page) async {
    try {
      final response = await dio.get('/api/admin/Employees', queryParameters: {'page': page});
      final data = _processResponse(response);
      return PaginatedEmployeesModel.fromJson(data['data']);
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(errorMessageModel: ErrorMessageModel.fromDioError(e));
    }
  }

  @override
  Future<void> deleteEmployee(int employeeId) async {
    try {
      final response = await dio.delete('/api/admin/Employees/$employeeId');
      _processResponse(response);
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(errorMessageModel: ErrorMessageModel.fromDioError(e));
    }
  }

  @override
  Future<void> updateEmployee(UpdateEmployeeEntity entity) async {
    try {
      final response = await dio.put('/api/admin/Employees/${entity.id}', data: entity.toJson());
      _processResponse(response);
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(errorMessageModel: ErrorMessageModel.fromDioError(e));
    }
  }
}
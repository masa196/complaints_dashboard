
import 'package:dartz/dartz.dart';
import 'package:untitled/domain/repository/employees_management/base_management_employees.dart';
import '../../../core/error/exceptions.dart';
import '../../../core/error/failure.dart';
import '../../../domain/entities/employees/update_employee_entity.dart';
import '../../dataSource/employees_management/management_employees_data_source.dart';
import '../../models/employees/paginated_employees_model.dart';


class ManagementEmployeeRepo extends BaseManagementEmployeesRepository {
  final ManagementEmployeesDataSource remote;

  ManagementEmployeeRepo(this.remote);

  @override
  Future<Either<Failure, PaginatedEmployeesModel>> getEmployee(int page) async {
    try {
      final result = await remote.getEmployees(page);
      return Right(result);
    } on ServerException catch (e) {
      return Left( ServerFailure(
        e.errorMessageModel.userFriendlyMessage(),
        retryAfterSeconds: e.errorMessageModel.retryAfterSeconds,
      ),);
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteEmployee(int employeeId) async {
    try {
      await remote.deleteEmployee(employeeId);
      return const Right(unit);
    } on ServerException catch (e) {
      return Left( ServerFailure(
        e.errorMessageModel.userFriendlyMessage(),
        retryAfterSeconds: e.errorMessageModel.retryAfterSeconds,
      ),);
    }
  }

  @override
  Future<Either<Failure, Unit>> updateEmployee(UpdateEmployeeEntity entity) async {
    try {
      await remote.updateEmployee(entity);
      return const Right(unit);
    } on ServerException catch (e) {
      return Left( ServerFailure(
        e.errorMessageModel.userFriendlyMessage(),
        retryAfterSeconds: e.errorMessageModel.retryAfterSeconds,
      ),);
    }
  }


}

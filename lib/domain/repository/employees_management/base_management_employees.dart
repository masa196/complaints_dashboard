import 'package:dartz/dartz.dart';
import 'package:untitled/data/models/employees/paginated_employees_model.dart';
import '../../../core/error/failure.dart';
import '../../entities/employees/update_employee_entity.dart';

abstract class BaseManagementEmployeesRepository {
  Future<Either<Failure, PaginatedEmployeesModel>> getEmployee(int page);
  Future<Either<Failure, Unit>> deleteEmployee(int employeeId);
  Future<Either<Failure, Unit>> updateEmployee(UpdateEmployeeEntity entity);
}

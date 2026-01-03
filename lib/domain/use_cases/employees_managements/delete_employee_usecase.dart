import 'package:dartz/dartz.dart';
import '../../../core/error/failure.dart';
import '../../repository/employees_management/base_management_employees.dart';


class DeleteEmployeeUseCase  {
  final BaseManagementEmployeesRepository repository;

  DeleteEmployeeUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(int employeeId) {
    return repository.deleteEmployee(employeeId);
  }
}

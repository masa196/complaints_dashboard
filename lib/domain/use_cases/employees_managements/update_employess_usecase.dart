import 'package:dartz/dartz.dart';
import 'package:untitled/domain/entities/employees/update_employee_entity.dart';
import '../../../core/error/failure.dart';

import '../../repository/employees_management/base_management_employees.dart';

class UpdateEmployeeUseCase  {
  final BaseManagementEmployeesRepository repository;

  UpdateEmployeeUseCase(this.repository);


  Future<Either<Failure, Unit>> call(UpdateEmployeeEntity params) {
    return repository.updateEmployee(params);
  }
}

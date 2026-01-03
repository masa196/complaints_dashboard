import 'package:dartz/dartz.dart';
import '../../../core/error/failure.dart';
import '../../../data/models/employees/paginated_employees_model.dart';
import '../../repository/employees_management/base_management_employees.dart';


class GetEmployeesUseCase {
  final BaseManagementEmployeesRepository repository;

  GetEmployeesUseCase(this.repository);

  Future<Either<Failure, PaginatedEmployeesModel>> call(int page) {
    return repository.getEmployee(page);
  }
}

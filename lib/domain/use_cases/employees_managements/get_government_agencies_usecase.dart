import 'package:dartz/dartz.dart';
import 'package:untitled/data/models/employees/government_agencies_model.dart';
import '../../../core/error/failure.dart';
import '../../repository/employees_management/base_create_email_repo.dart';


class GetGovernmentAgenciesUseCase {
  final BaseCreateEmailRepo repo;

  GetGovernmentAgenciesUseCase(this.repo);

  Future<Either<Failure, GovernmentAgenciesModel>>
  execute() async {
    return await repo.getGovernmentAgencies();
  }
}

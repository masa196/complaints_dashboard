import 'package:dartz/dartz.dart';
import '../../../core/error/failure.dart';
import '../../entities/auth/login_response.dart';
import '../../repository/employees_management/base_create_email_repo.dart';


class CreateEmailUseCase {
  final BaseCreateEmailRepo repo;
  
  CreateEmailUseCase(this.repo);

  Future<Either<Failure, LoginResponse>>
  execute(String name ,String email, String password ,String passwordConfirmation,int governmentAgencyId) async {
    return await repo.createEmail(name, email, password, passwordConfirmation,governmentAgencyId);
  }
}

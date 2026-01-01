// lib/auth_admin/domain/usecases/login_usecase.dart
import 'package:dartz/dartz.dart';
import '../../../core/error/failure.dart';
import '../../entities/auth/login_response.dart';
import '../../repository/auth/base_login_repo.dart';

class LoginUseCase {
  final BaseLoginRepo repo;
  LoginUseCase(this.repo);

  Future<Either<Failure, LoginResponse>> execute(String email, String password) async {
    return await repo.login(email, password);
  }
}

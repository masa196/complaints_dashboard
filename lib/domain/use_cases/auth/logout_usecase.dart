// lib/auth_admin/domain/usecases/logout_usecase.dart
import 'package:dartz/dartz.dart';
import '../../../core/error/failure.dart';
import '../../repository/auth/base_login_repo.dart';

class LogoutUseCase {
  final BaseLoginRepo repo;
  LogoutUseCase(this.repo);

  Future<Either<Failure, bool>> execute() async {
    return await repo.logout();
  }
}

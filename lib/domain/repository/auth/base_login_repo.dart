import 'package:dartz/dartz.dart';
import '../../../core/error/failure.dart';
import '../../entities/auth/login_response.dart';

abstract class BaseLoginRepo {
  Future<Either<Failure, LoginResponse>> login(String email, String password);
  Future<Either<Failure, bool>> logout();

}

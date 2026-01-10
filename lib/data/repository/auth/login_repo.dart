

import 'package:dartz/dartz.dart';
import '../../../core/error/exceptions.dart';
import '../../../core/error/failure.dart';
import '../../../domain/entities/auth/login_response.dart';
import '../../../domain/repository/auth/base_login_repo.dart';
import '../../dataSource/auth/login_remote_data_source.dart';


class LoginRepo implements BaseLoginRepo {
  final BaseLoginRemoteDataSource remoteDataSource;
  LoginRepo(this.remoteDataSource);

  @override
  Future<Either<Failure, LoginResponse>> login(String email, String password) async {
    try {
      final result = await remoteDataSource.login(email, password);
      return Right(result);
    } on ServerException catch (e) {
      return Left(
        ServerFailure(
          e.errorMessageModel.userFriendlyMessage(),
          retryAfterSeconds: e.errorMessageModel.retryAfterSeconds,
        ),
      );
    } catch (e) {
      return Left(ServerFailure("حدث خطأ غير متوقع"));
    }
  }

  @override
  Future<Either<Failure, bool>> logout() async {
    try {
      final res = await remoteDataSource.logout();
      return Right(res);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.errorMessageModel.userFriendlyMessage()));
    } catch (e) {
      return Left(ServerFailure("حدث خطأ غير متوقع"));
    }
  }
}

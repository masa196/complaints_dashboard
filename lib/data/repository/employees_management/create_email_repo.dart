

import 'package:dartz/dartz.dart';
import '../../../core/error/exceptions.dart';
import '../../../core/error/failure.dart';
import '../../../domain/entities/auth/login_response.dart';
import '../../../domain/repository/employees_management/base_create_email_repo.dart';
import '../../dataSource/employees_management/create_email_data_source.dart';
import '../../models/employees/government_agencies_model.dart';



class CreateEmailRepo implements BaseCreateEmailRepo {
  final BaseCreateEmailDataSource baseCreateEmailDataSource;
  CreateEmailRepo(this.baseCreateEmailDataSource);

  @override
  Future<Either<Failure, LoginResponse>> createEmail(
      String name, String email, String password, String passwordConfirmation, int governmentAgencyId) async {
    try {
      final result = await baseCreateEmailDataSource.createEmail(
          name, email, password, passwordConfirmation, governmentAgencyId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(
        e.errorMessageModel.userFriendlyMessage(),
        retryAfterSeconds: e.errorMessageModel.retryAfterSeconds,
      ));
    } catch (e) {
      return Left(ServerFailure("حدث خطأ غير متوقع"));
    }
  }

  @override
  Future<Either<Failure, GovernmentAgenciesModel>> getGovernmentAgencies() async {
    try {
      final result = await baseCreateEmailDataSource.getGovernmentAgencies();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.errorMessageModel.userFriendlyMessage()));
    } catch (e) {
      return Left(ServerFailure("حدث خطأ أثناء جلب البيانات"));
    }
  }
}


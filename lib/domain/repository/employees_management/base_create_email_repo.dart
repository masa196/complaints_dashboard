
import 'package:dartz/dartz.dart';
import 'package:untitled/data/models/employees/government_agencies_model.dart';

import '../../../core/error/failure.dart';
import '../../entities/auth/login_response.dart';

abstract class BaseCreateEmailRepo{
  Future<Either<Failure, LoginResponse>>
  createEmail(String name ,String email, String password ,String passwordConfirmation, int governmentAgencyId);
  Future<Either<Failure, GovernmentAgenciesModel>> getGovernmentAgencies();

}
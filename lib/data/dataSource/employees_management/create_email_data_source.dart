import 'package:dio/dio.dart';
import '../../models/employees/government_agencies_model.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/error/exceptions.dart';
import '../../../core/network/api_response_model.dart';
import '../../../core/network/error_message_model.dart';
import '../../../core/utils/AuthInterceptor.dart';
import '../../models/auth/login_response_model.dart';

abstract class BaseCreateEmailDataSource {
  Future<LoginResponseModel> createEmail(String name, String email, String password, String passwordConfirmation, int governmentAgencyId);
  Future<GovernmentAgenciesModel> getGovernmentAgencies();
}

class CreateEmailDataSource implements BaseCreateEmailDataSource {
  final Dio dio;

  CreateEmailDataSource({Dio? dio})
      : dio = dio ?? Dio(BaseOptions(baseUrl: ApiConstants.baseUrl)) {
    this.dio.interceptors.add(AuthInterceptor());
    this.dio.options.headers.addAll({
      'Accept': 'application/json',
      'X-Requested-With': 'XMLHttpRequest',
    });
    this.dio.options.validateStatus = (status) => true;
  }

  @override
  Future<LoginResponseModel> createEmail(String name, String email, String password, String passwordConfirmation, int governmentAgencyId) async {
    try {
      final response = await dio.post(
        ApiConstants.createEmailUrl,
        data: {
          'name': name,
          'email': email,
          'password': password,
          'password_confirmation': passwordConfirmation,
          'government_agency_id': governmentAgencyId,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data is Map) {
          final apiEnvelope = ApiResponseModel.fromJson(response.data);
          return LoginResponseModel.fromJson(apiEnvelope.data!);
        }
      }
      throw ServerException(errorMessageModel: ErrorMessageModel.handleResponse(response));
    } on DioException catch (e) {
      throw ServerException(errorMessageModel: ErrorMessageModel.fromDioError(e));
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(errorMessageModel: ErrorMessageModel(message: e.toString()));
    }
  }

  @override
  Future<GovernmentAgenciesModel> getGovernmentAgencies() async {
    try {
      final response = await dio.get('/api/admin/government-agencies');
      if (response.statusCode == 200 && response.data is Map) {
        return GovernmentAgenciesModel.fromJson(response.data);
      }
      throw ServerException(errorMessageModel: ErrorMessageModel.handleResponse(response));
    } on DioException catch (e) {
      throw ServerException(errorMessageModel: ErrorMessageModel.fromDioError(e));
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(errorMessageModel: ErrorMessageModel(message: e.toString()));
    }
  }
}
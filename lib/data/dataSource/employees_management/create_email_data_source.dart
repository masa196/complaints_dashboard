// lib/auth_admin/data/dataSource/create_email_data_source.dart
import 'package:dio/dio.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/error/exceptions.dart';
import '../../../core/network/api_response_model.dart';
import '../../../core/network/error_message_model.dart';
import '../../../core/utils/AuthInterceptor.dart';
import '../../models/auth/login_response_model.dart';


abstract class BaseCreateEmailDataSource {
  Future<LoginResponseModel> createEmail(String name, String email, String password, String passwordConfirmation,int governmentAgencyId);
}

class CreateEmailDataSource implements BaseCreateEmailDataSource {
  final Dio dio;


  CreateEmailDataSource({Dio? dio})
      : dio = dio ?? Dio(BaseOptions(
    baseUrl: ApiConstants.baseUrl,

  )) {
    this.dio.interceptors.add(AuthInterceptor());
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
        options: Options(responseType: ResponseType.json),
      );

      if (response.data is Map<String, dynamic>) {
        final apiEnvelope = ApiResponseModel.fromJson(Map<String, dynamic>.from(response.data));

        if (apiEnvelope.success == true && apiEnvelope.data != null) {
          final dataMap = Map<String, dynamic>.from(apiEnvelope.data!);
          return LoginResponseModel.fromJson(dataMap);
        } else {
          // Return ServerException with parsed ErrorMessageModel (includes errors map)
          throw ServerException(
            errorMessageModel: ErrorMessageModel.fromJson(Map<String, dynamic>.from(response.data)),
          );
        }
      } else {
        throw ServerException(
          errorMessageModel: ErrorMessageModel.fromJson({'message': 'Invalid response from server'}),
        );
      }
    } on DioException catch (e) {
      if (e.response != null && e.response!.data != null && e.response!.data is Map<String, dynamic>) {
        throw ServerException(
          errorMessageModel: ErrorMessageModel.fromJson(Map<String, dynamic>.from(e.response!.data)),
        );
      } else {
        throw ServerException(errorMessageModel: ErrorMessageModel(message: e.message ?? 'Network error'));
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(errorMessageModel: ErrorMessageModel(message: e.toString()));
    }
  }
}

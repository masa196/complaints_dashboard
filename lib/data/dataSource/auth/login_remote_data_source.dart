// lib/auth_admin/data/dataSource/login_remote_data_source.dart
import 'package:dio/dio.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/error/exceptions.dart';
import '../../../core/network/api_response_model.dart';
import '../../../core/network/error_message_model.dart';
import '../../../core/utils/AuthInterceptor.dart';
import '../../models/auth/login_response_model.dart';


abstract class BaseLoginRemoteDataSource {
  Future<LoginResponseModel> login(String email, String password);
  Future<bool> logout();
}

class LoginRemoteDataSource implements BaseLoginRemoteDataSource {
  final Dio dio;

  LoginRemoteDataSource({Dio? dio})
      : dio = dio ??
      Dio(BaseOptions(
        baseUrl: ApiConstants.baseUrl,
      )) {
    this.dio.interceptors.add(AuthInterceptor());
    this.dio.options.validateStatus = (status) => true;
  }

  @override
  Future<LoginResponseModel> login(String email, String password) async {
    try {
      final response = await dio.post(
        ApiConstants.loginUrl,
        data: {'email': email, 'password': password},
        options: Options(
          headers: {'Content-Type': 'application/json'},
          responseType: ResponseType.json,
        ),
      );


      if (response.data is! Map) {
        throw ServerException(
          errorMessageModel: ErrorMessageModel.fromJson(
            {"message": "Invalid server response"},
          ),
        );
      }

      final Map<String, dynamic> map =
      Map<String, dynamic>.from(response.data);

      final apiEnvelope = ApiResponseModel.fromJson(map);

      if (apiEnvelope.success == true && apiEnvelope.data != null) {
        return LoginResponseModel.fromJson(
            Map<String, dynamic>.from(apiEnvelope.data!));
      }


      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(map),
      );
    } on DioException catch (e) {

      if (e.response?.data is Map) {
        throw ServerException(
          errorMessageModel:
          ErrorMessageModel.fromJson(Map<String, dynamic>.from(e.response!.data)),
        );
      }

      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(
          {"message": e.message ?? "Network error"},
        ),
      );
    }
  }

  @override
  Future<bool> logout() async {
    try {
      final response = await dio.post(
        ApiConstants.logoutUrl,
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.data is! Map) {
        throw ServerException(
          errorMessageModel:
          ErrorMessageModel.fromJson({"message": "Invalid server response"}),
        );
      }

      final map = Map<String, dynamic>.from(response.data);
      final apiEnvelope = ApiResponseModel.fromJson(map);

      if (apiEnvelope.success == true) return true;

      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson(map),
      );
    } on DioException catch (e) {
      if (e.response?.data is Map) {
        throw ServerException(
          errorMessageModel:
          ErrorMessageModel.fromJson(Map<String, dynamic>.from(e.response!.data)),
        );
      }
      throw ServerException(
        errorMessageModel:
        ErrorMessageModel.fromJson({"message": e.message ?? "Network error"}),
      );
    }
  }
}

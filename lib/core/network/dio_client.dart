// lib/core/network/dio_client.dart
import 'package:dio/dio.dart';
import '../constants/api_constants.dart';
import '../utils/AuthInterceptor.dart';

class DioClient {
  DioClient._internal() {
    dio = Dio(BaseOptions(baseUrl: ApiConstants.baseUrl))
      ..interceptors.add(AuthInterceptor())
      ..options.validateStatus = (status) => true;
  }

  static final DioClient _instance = DioClient._internal();
  static DioClient get instance => _instance;

  late final Dio dio;
}

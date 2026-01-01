// lib/core/network/auth_interceptor.dart
import 'package:dio/dio.dart';
import '../utils/token_service.dart';

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = TokenService().token;
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    options.headers['Content-Type'] = 'application/json';
    super.onRequest(options, handler);
  }
}

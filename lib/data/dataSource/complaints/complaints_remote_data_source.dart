import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/error_message_model.dart';
import '../../../../core/utils/token_service.dart';

abstract class BaseComplaintsRemoteDataSource {
  Future<Map<String, dynamic>> lockComplaint(int id);
  Future<Map<String, dynamic>> updateStatus(int id, String status);
  Future<Map<String, dynamic>> requestInfo(int id, String requestText);
  Future<Map<String, dynamic>> unlockComplaint(int id);
  Future<Map<String, dynamic>> fetchAgencyComplaints({int page = 1});
}

class ComplaintsRemoteDataSource implements BaseComplaintsRemoteDataSource {
  final Dio dio;

  ComplaintsRemoteDataSource({Dio? dio})
      : dio = dio ?? DioClient.instance.dio {
    this.dio.options.headers.addAll({
      'Accept': 'application/json',
      'X-Requested-With': 'XMLHttpRequest',
    });
    this.dio.options.validateStatus = (s) => true;
  }

  Map<String, dynamic> _parseResponse(Response res) {
    if (res.statusCode != null && res.statusCode! >= 200 && res.statusCode! < 300) {
      if (res.data is Map) return Map<String, dynamic>.from(res.data);
    }
    throw ServerException(errorMessageModel: ErrorMessageModel.handleResponse(res));
  }

  Options _authOptions() {
    final token = TokenService().token;
    final headers = <String, String>{'Content-Type': 'application/json'};
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    return Options(headers: headers);
  }

  @override
  Future<Map<String, dynamic>> lockComplaint(int id) async {
    try {
      final res = await dio.post('${ApiConstants.baseUrl}/api/admin/agency/complaints/$id/lock', options: _authOptions());
      return _parseResponse(res);
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(errorMessageModel: ErrorMessageModel.fromDioError(e));
    }
  }

  @override
  Future<Map<String, dynamic>> updateStatus(int id, String status) async {
    try {
      final res = await dio.post('${ApiConstants.baseUrl}/api/admin/agency/complaints/$id/status', data: {'status': status}, options: _authOptions());
      return _parseResponse(res);
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(errorMessageModel: ErrorMessageModel.fromDioError(e));
    }
  }

  @override
  Future<Map<String, dynamic>> requestInfo(int id, String requestText) async {
    try {
      final res = await dio.post('${ApiConstants.baseUrl}/api/admin/complaints/$id/request-info', data: {'request_text': requestText}, options: _authOptions());
      return _parseResponse(res);
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(errorMessageModel: ErrorMessageModel.fromDioError(e));
    }
  }

  @override
  Future<Map<String, dynamic>> unlockComplaint(int id) async {
    try {
      final res = await dio.post('${ApiConstants.baseUrl}/api/admin/agency/complaints/$id/unlock', options: _authOptions());
      return _parseResponse(res);
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(errorMessageModel: ErrorMessageModel.fromDioError(e));
    }
  }

  @override
  Future<Map<String, dynamic>> fetchAgencyComplaints({int page = 1}) async {
    try {
      final res = await dio.get('${ApiConstants.baseUrl}/api/admin/agency/complaints', queryParameters: {'page': page}, options: _authOptions());
      return _parseResponse(res);
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(errorMessageModel: ErrorMessageModel.fromDioError(e));
    }
  }
}
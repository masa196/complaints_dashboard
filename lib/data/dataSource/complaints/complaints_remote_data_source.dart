// lib/employee_dashboard/data/data_source/complaints_remote_data_source.dart
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
    this.dio.options.validateStatus = (s) => true;
  }

  Map<String, dynamic> _parseResponse(Response res) {
    if (res.data is! Map) {
      throw ServerException(
        errorMessageModel: ErrorMessageModel.fromJson({"message": "Invalid server response"}),
      );
    }
    return Map<String, dynamic>.from(res.data as Map);
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
    final url = '${ApiConstants.baseUrl}/api/admin/agency/complaints/$id/lock';
    final res = await dio.post(url, options: _authOptions());
    final data = _parseResponse(res);
    return data;
  }

  @override
  Future<Map<String, dynamic>> updateStatus(int id, String status) async {
    final url = '${ApiConstants.baseUrl}/api/admin/agency/complaints/$id/status';
    final res = await dio.post(url, data: {'status': status}, options: _authOptions());
    final data = _parseResponse(res);
    return data;
  }

  @override
  Future<Map<String, dynamic>> requestInfo(int id, String requestText) async {
    final url = '${ApiConstants.baseUrl}/api/admin/complaints/$id/request-info';
    final res = await dio.post(url, data: {'request_text': requestText}, options: _authOptions());
    final data = _parseResponse(res);
    return data;
  }

  @override
  Future<Map<String, dynamic>> unlockComplaint(int id) async {
    final url = '${ApiConstants.baseUrl}/api/admin/agency/complaints/$id/unlock';
    final res = await dio.post(url, options: _authOptions());
    final data = _parseResponse(res);
    return data;
  }

  @override
  Future<Map<String, dynamic>> fetchAgencyComplaints({int page = 1}) async {
    final res = await dio.get(
      '${ApiConstants.baseUrl}/api/admin/agency/complaints',
      queryParameters: {'page': page},
      options: _authOptions(),
    );
    final data = _parseResponse(res);
    return data;
  }
}

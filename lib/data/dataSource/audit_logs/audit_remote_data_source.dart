import 'package:dio/dio.dart';
import '../../../core/constants/api_constants.dart';
import '../../models/audit_log/audit_log_model.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/error_message_model.dart';

abstract class BaseAuditRemoteDataSource {
  Future<AuditResponseModel> getAuditLogs(int page);
}

class AuditRemoteDataSource implements BaseAuditRemoteDataSource {
  final Dio dio;

  AuditRemoteDataSource({required this.dio}) {

    this.dio.options.headers.addAll({
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'X-Requested-With': 'XMLHttpRequest',
    });
    this.dio.options.validateStatus = (status) => true;
  }

  @override
  Future<AuditResponseModel> getAuditLogs(int page) async {
    try {
      final response = await dio.get(
        '${ApiConstants.baseUrl}/api/admin/audit-logs',
        queryParameters: {'page': page},
      );

      if (response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300) {
        if (response.data is Map) {
          return AuditResponseModel.fromJson(response.data);
        }
      }


      throw ServerException(
        errorMessageModel: ErrorMessageModel.handleResponse(response),
      );

    } on DioException catch (e) {
      throw ServerException(errorMessageModel: ErrorMessageModel.fromDioError(e));
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(
        errorMessageModel: ErrorMessageModel(message: "خطأ غير متوقع: ${e.toString()}"),
      );
    }
  }
}
import 'dart:typed_data';
import 'dart:js_interop';
import 'package:web/web.dart' as web;
import 'package:dio/dio.dart';
import 'dart:convert';
import '../../../core/constants/api_constants.dart';
import '../../models/statistics/statistics_model.dart';
import '../../../core/error/exceptions.dart';
import '../../../core/network/error_message_model.dart';

abstract class BaseStatisticRemoteDataSource {
  Future<StatisticsModel> getStatistic();
  Future<void> downloadReport(String type);
}

class StatisticReomteDataSource implements BaseStatisticRemoteDataSource {
  final Dio dio;
  StatisticReomteDataSource({required this.dio}) {
    this.dio.options.headers.addAll({
      'Accept': 'application/json',
      'X-Requested-With': 'XMLHttpRequest',
    });
    this.dio.options.validateStatus = (status) => true;
  }

  dynamic _processJsonResponse(Response response) {
    if (response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300) {
      if (response.data is Map) return response.data;
    }
    throw ServerException(errorMessageModel: ErrorMessageModel.handleResponse(response));
  }

  @override
  Future<StatisticsModel> getStatistic() async {
    try {
      final response = await dio.get('${ApiConstants.baseUrl}/api/admin/dashboard/stats');
      final data = _processJsonResponse(response);
      return StatisticsModel.fromJson(data);
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(errorMessageModel: ErrorMessageModel.fromDioError(e));
    }
  }

  @override
  Future<void> downloadReport(String type) async {
    final String endpoint = type == 'csv'
        ? '/api/admin/reports/complaints/csv'
        : '/api/admin/reports/complaints/pdf';

    try {
      final response = await dio.get(
        '${ApiConstants.baseUrl}$endpoint',
        options: Options(responseType: ResponseType.bytes),
      );

      if (response.statusCode == 200) {
        final List<int> bytes = response.data as List<int>;
        _triggerFileDownload(bytes, type);
      } else {

        try {
          final String decoded = utf8.decode(response.data as List<int>);
          final mockResponse = Response(
            requestOptions: response.requestOptions,
            data: decoded.contains('{') ? jsonDecode(decoded) : decoded,
            statusCode: response.statusCode,
          );
          throw ServerException(errorMessageModel: ErrorMessageModel.handleResponse(mockResponse));
        } catch (e) {
          if (e is ServerException) rethrow;
          throw ServerException(
            errorMessageModel: ErrorMessageModel(message: "فشل تحميل الملف (${response.statusCode})"),
          );
        }
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(errorMessageModel: ErrorMessageModel.fromDioError(e));
    }
  }

  void _triggerFileDownload(List<int> bytes, String type) {
    final uint8list = Uint8List.fromList(bytes);
    final uint8array = uint8list.toJS;
    final mimeType = type == 'pdf' ? 'application/pdf' : 'text/csv';

    final blob = web.Blob([uint8array].toJS, web.BlobPropertyBag(type: mimeType));
    final url = web.URL.createObjectURL(blob);
    final anchor = web.document.createElement('a') as web.HTMLAnchorElement;
    anchor.href = url;
    anchor.download = "report_${DateTime.now().millisecondsSinceEpoch}.$type";
    anchor.click();
    web.URL.revokeObjectURL(url);
  }
}
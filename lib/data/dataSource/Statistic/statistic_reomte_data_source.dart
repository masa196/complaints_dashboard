import 'dart:typed_data'; // الاستيراد الناقص لحل مشكلة Uint8List
import 'dart:js_interop';
import 'package:web/web.dart' as web;
import 'package:dio/dio.dart';
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
  StatisticReomteDataSource({required this.dio});

  @override
  Future<StatisticsModel> getStatistic() async {
    final response = await dio.get('${ApiConstants.baseUrl}/api/admin/dashboard/stats');
    if (response.statusCode == 200) {
      return StatisticsModel.fromJson(response.data);
    } else {
      throw ServerException(errorMessageModel: ErrorMessageModel.fromJson(response.data));
    }
  }

  @override
  Future<void> downloadReport(String type) async {
    final String endpoint = type == 'csv'
        ? '/api/admin/reports/complaints/csv'
        : '/api/admin/reports/complaints/pdf';

    final response = await dio.get(
      '${ApiConstants.baseUrl}$endpoint',
      options: Options(responseType: ResponseType.bytes),
    );

    if (response.statusCode == 200) {
      // التأكد من أن البيانات القادمة هي قائمة من الـ bytes
      final List<int> bytes = response.data as List<int>;
      _triggerFileDownload(bytes, type);
    } else {
      throw ServerException(errorMessageModel: ErrorMessageModel.fromJson(response.data));
    }
  }

  void _triggerFileDownload(List<int> bytes, String type) {
    // 1. تحويل القائمة إلى Uint8List ثم إلى JS Uint8Array
    final uint8list = Uint8List.fromList(bytes);
    final uint8array = uint8list.toJS;

    // 2. تحديد نوع الـ MIME
    final mimeType = type == 'pdf' ? 'application/pdf' : 'text/csv';

    // 3. إنشاء Blob (متوافق مع package:web)
    final blob = web.Blob(
        [uint8array].toJS,
        web.BlobPropertyBag(type: mimeType)
    );

    // 4. توليد رابط تحميل مؤقت
    final url = web.URL.createObjectURL(blob);

    // 5. إنشاء عنصر a (Anchor) مخفي للتحميل
    final anchor = web.document.createElement('a') as web.HTMLAnchorElement;
    anchor.href = url;
    anchor.download = "report_${DateTime.now().millisecondsSinceEpoch}.$type";

    // 6. تفعيل التحميل وحذف الرابط من الذاكرة
    anchor.click();
    web.URL.revokeObjectURL(url);
  }
}
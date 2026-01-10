// data/dataSource/complaints/admin_complaints_remote_data_source.dart
import 'package:dio/dio.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/error/exceptions.dart';
import '../../../core/network/error_message_model.dart';
import '../../models/complaint_for_admin/complaints_for_admin_model.dart';

class AdminComplaintsRemoteDataSource {
  final Dio dio;
  AdminComplaintsRemoteDataSource({required this.dio}) {
    this.dio.options.headers.addAll({
      'Accept': 'application/json',
      'X-Requested-With': 'XMLHttpRequest',
    });
    this.dio.options.validateStatus = (s) => true;
  }

  Future<ComplaintsForAdminModel> getComplaints({String? status}) async {
    try {
      Response response;
      if (status == null) {
        response = await dio.get('${ApiConstants.baseUrl}/api/admin/complaints');
      } else {
        response = await dio.post(
          '${ApiConstants.baseUrl}/api/admin/complaints/by-status',
          data: {'status': status},
        );
      }

      if (response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300) {
        return ComplaintsForAdminModel.fromJson(response.data);
      }

      throw ServerException(errorMessageModel: ErrorMessageModel.handleResponse(response));
    } on DioException catch (e) {
      throw ServerException(errorMessageModel: ErrorMessageModel.fromDioError(e));
    }
  }
}
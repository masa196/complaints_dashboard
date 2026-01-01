
import '../../../domain/entities/compaints/complaint.dart';
import '../../../domain/repository/complaints/base_complaints_repo.dart';
import '../../dataSource/complaints/complaints_remote_data_source.dart';
import '../../models/complaints/complaint_model.dart';
import '../../models/pagination_result.dart';


class ComplaintsRepository implements BaseComplaintsRepository {
  final BaseComplaintsRemoteDataSource remote;

  ComplaintsRepository(this.remote);

  @override
  Future<PaginationResult<Complaint>> getAgencyComplaints({int page = 1}) async {
    final map = await remote.fetchAgencyComplaints(page: page);

    if (map['success'] == true && map['data'] is Map) {
      final data = Map<String, dynamic>.from(map['data']);

      final List<Complaint> complaints = (data['data'] as List)
          .map((e) => ComplaintModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();

      return PaginationResult<Complaint>(
        data: complaints,
        currentPage: data['current_page'],
        lastPage: data['last_page'],
      );
    }

    throw Exception(map['message'] ?? 'Failed to load complaints');
  }

  @override
  Future<Map<String, dynamic>> lockComplaint(int id) => remote.lockComplaint(id);

  @override
  Future<Map<String, dynamic>> updateStatus(int id, String status) =>
      remote.updateStatus(id, status);

  @override
  Future<Map<String, dynamic>> requestInfo(int id, String requestText) =>
      remote.requestInfo(id, requestText);

  @override
  Future<Map<String, dynamic>> unlockComplaint(int id) =>
      remote.unlockComplaint(id);
}

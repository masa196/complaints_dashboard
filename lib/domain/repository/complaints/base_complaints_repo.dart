
import '../../../data/models/pagination_result.dart';
import '../../entities/compaints/complaint.dart';

abstract class BaseComplaintsRepository {
  Future<PaginationResult<Complaint>> getAgencyComplaints({int page = 1});
  Future<Map<String, dynamic>> lockComplaint(int id);
  Future<Map<String, dynamic>> updateStatus(int id, String status);
  Future<Map<String, dynamic>> requestInfo(int id, String requestText);
  Future<Map<String, dynamic>> unlockComplaint(int id);
}

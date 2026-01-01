// lib/employee_dashboard/domain/entities/complaint.dart
class Complaint {
  final int id;
  final int userId;
  final int governmentAgencyId;
  final String referenceNumber;
  final String title;
  final String description;
  final String location;
  final String status;
  final int? lockedByAdminId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<ComplaintImage> images;

  Complaint({
    required this.id,
    required this.userId,
    required this.governmentAgencyId,
    required this.referenceNumber,
    required this.title,
    required this.description,
    required this.location,
    required this.status,
    required this.lockedByAdminId,
    required this.createdAt,
    required this.updatedAt,
    required this.images,
  });
}

class ComplaintImage {
  final int id;
  final int complaintId;
  final String filePath;
  final DateTime createdAt;
  final DateTime updatedAt;

  ComplaintImage({
    required this.id,
    required this.complaintId,
    required this.filePath,
    required this.createdAt,
    required this.updatedAt,
  });
}

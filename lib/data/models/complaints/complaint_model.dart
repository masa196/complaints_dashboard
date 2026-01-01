// lib/employee_dashboard/data/models/complaint_model.dart
import '../../../domain/entities/compaints/complaint.dart';

class ComplaintModel extends Complaint {
  ComplaintModel({
    required super.id,
    required super.userId,
    required super.governmentAgencyId,
    required super.referenceNumber,
    required super.title,
    required super.description,
    required super.location,
    required super.status,
    required super.lockedByAdminId,
    required super.createdAt,
    required super.updatedAt,
    required super.images,
  });

  factory ComplaintModel.fromJson(Map<String, dynamic> json) {
    List<ComplaintImage> images = [];
    if (json['images'] is List) {
      images = (json['images'] as List)
          .map((e) => ComplaintImageModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    }

    return ComplaintModel(
      id: json['id'] is int ? json['id'] as int : int.parse(json['id'].toString()),
      userId: json['user_id'] is int ? json['user_id'] as int : int.parse(json['user_id'].toString()),
      governmentAgencyId: json['government_agency_id'] is int ? json['government_agency_id'] as int : int.parse(json['government_agency_id'].toString()),
      referenceNumber: json['reference_number'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      location: json['location'] as String? ?? '',
      status: json['status'] as String? ?? '',
      lockedByAdminId: json['locked_by_admin_id'] == null ? null : (json['locked_by_admin_id'] is int ? json['locked_by_admin_id'] as int : int.tryParse(json['locked_by_admin_id'].toString())),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      images: images,
    );
  }
}

class ComplaintImageModel extends ComplaintImage {
  ComplaintImageModel({
    required super.id,
    required super.complaintId,
    required super.filePath,
    required super.createdAt,
    required super.updatedAt,
  });

  factory ComplaintImageModel.fromJson(Map<String, dynamic> json) {
    return ComplaintImageModel(
      id: json['id'] is int ? json['id'] as int : int.parse(json['id'].toString()),
      complaintId: json['complaint_id'] is int ? json['complaint_id'] as int : int.parse(json['complaint_id'].toString()),
      filePath: json['file_path'] as String? ?? '',
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }
}

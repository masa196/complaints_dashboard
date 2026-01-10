// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'complaints_for_admin_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ComplaintsForAdminModel _$ComplaintsForAdminModelFromJson(
  Map<String, dynamic> json,
) => ComplaintsForAdminModel(
  success: json['success'] as bool?,
  statusCode: (json['status_code'] as num?)?.toInt(),
  message: json['message'] as String?,
  data: (json['data'] as List<dynamic>?)
      ?.map((e) => DatumForAdmin.fromJson(e as Map<String, dynamic>))
      .toList(),
  errors: json['errors'] as List<dynamic>?,
);

DatumForAdmin _$DatumForAdminFromJson(Map<String, dynamic> json) =>
    DatumForAdmin(
      id: (json['id'] as num?)?.toInt(),
      userId: (json['user_id'] as num?)?.toInt(),
      governmentAgencyId: (json['government_agency_id'] as num?)?.toInt(),
      referenceNumber: json['reference_number'] as String?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      location: json['location'] as String?,
      status: json['status'] as String?,
      lockedByAdminId: json['locked_by_admin_id'],
      lockedAt: json['locked_at'],
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      user: json['user'] == null
          ? null
          : Agency2.fromJson(json['user'] as Map<String, dynamic>),
      agency: json['agency'] == null
          ? null
          : Agency2.fromJson(json['agency'] as Map<String, dynamic>),
    );

Agency2 _$Agency2FromJson(Map<String, dynamic> json) =>
    Agency2(id: (json['id'] as num?)?.toInt(), name: json['name'] as String?);
